/*
 * JWAN DATA RETENTION
 *
 * Spark-safe:
 * AI JWAN        -> 14 days (localStorage)
 * Notifications  -> 30 days (current user's own notifications)
 * Negotiations   -> 30 days, only CLOSED/AGREED negotiations
 *
 * NEVER deletes:
 * orders
 * wallets
 * walletTransactions
 * users
 * ratings
 * auditLogs
 * supportMessages
 * topupRequests
 * withdrawalRequests
 */

import { db, auth } from "./firebase-config.js";

import {
  collection,
  collectionGroup,
  query,
  where,
  getDocs,
  getDoc,
  deleteDoc,
  doc,
  limit,
  Timestamp
} from "https://www.gstatic.com/firebasejs/12.18.0/firebase-firestore.js";

const RETENTION = {
  aiDays: 14,
  notificationsDays: 30,
  negotiationDays: 30
};

const MAX_DELETE_PER_RUN = 50;

function cutoffMillis(days) {
  return Date.now() - days * 24 * 60 * 60 * 1000;
}

function cutoffTimestamp(days) {
  return Timestamp.fromMillis(cutoffMillis(days));
}

function valueToMillis(value) {
  if (!value) return 0;

  if (typeof value.toMillis === "function") {
    return value.toMillis();
  }

  if (value instanceof Date) {
    return value.getTime();
  }

  const n = Number(value);

  if (Number.isFinite(n) && n > 0) {
    return n;
  }

  const d = new Date(value);

  return Number.isFinite(d.getTime())
    ? d.getTime()
    : 0;
}

/* =========================================================
 * AI JWAN — LOCAL STORAGE
 * ========================================================= */

export function cleanupAIChats() {
  try {
    const raw =
      localStorage.getItem("jawan_ai_chats");

    if (!raw) {
      return {
        ok: true,
        deleted: 0
      };
    }

    const chats = JSON.parse(raw);

    if (!Array.isArray(chats)) {
      return {
        ok: true,
        deleted: 0
      };
    }

    const cutoff =
      cutoffMillis(RETENTION.aiDays);

    const currentChatId =
      localStorage.getItem(
        "jawan_ai_current_chat"
      );

    let deleted = 0;

    const kept = chats.filter((chat) => {
      if (!chat || typeof chat !== "object") {
        deleted++;
        return false;
      }

      const messages =
        Array.isArray(chat.messages)
          ? chat.messages
          : [];

      /*
       * Empty conversations are kept.
       */
      if (!messages.length) {
        return true;
      }

      let latest = 0;

      for (const message of messages) {
        const t = Number(
          message?.time || 0
        );

        if (t > latest) {
          latest = t;
        }
      }

      /*
       * Never delete the currently selected chat.
       */
      if (chat.id === currentChatId) {
        return true;
      }

      if (
        latest > 0 &&
        latest < cutoff
      ) {
        deleted++;
        return false;
      }

      return true;
    });

    localStorage.setItem(
      "jawan_ai_chats",
      JSON.stringify(kept)
    );

    /*
     * Repair current-chat pointer.
     */
    if (
      currentChatId &&
      !kept.some(
        (chat) => chat.id === currentChatId
      )
    ) {
      if (kept.length) {
        localStorage.setItem(
          "jawan_ai_current_chat",
          kept[0].id
        );
      } else {
        localStorage.removeItem(
          "jawan_ai_current_chat"
        );
      }
    }

    return {
      ok: true,
      deleted
    };

  } catch (error) {
    console.warn(
      "Jwan retention: AI cleanup skipped:",
      error
    );

    return {
      ok: false,
      deleted: 0,
      error
    };
  }
}

/* =========================================================
 * NOTIFICATIONS
 * ========================================================= */

export async function cleanupNotifications() {
  const user = auth.currentUser;

  if (!user) {
    return {
      ok: true,
      skipped: true,
      reason: "not-authenticated",
      deleted: 0
    };
  }

  try {
    const q = query(
      collection(db, "notifications"),
      where("userId", "==", user.uid),
      where(
        "createdAt",
        "<",
        cutoffTimestamp(
          RETENTION.notificationsDays
        )
      ),
      limit(MAX_DELETE_PER_RUN)
    );

    const snap = await getDocs(q);

    let deleted = 0;

    for (const item of snap.docs) {
      try {
        /*
         * Extra ownership check.
         */
        if (
          item.data()?.userId !== user.uid
        ) {
          continue;
        }

        await deleteDoc(item.ref);
        deleted++;

      } catch (error) {
        console.warn(
          "Jwan retention: notification delete skipped:",
          item.id,
          error
        );
      }
    }

    return {
      ok: true,
      found: snap.size,
      deleted
    };

  } catch (error) {
    /*
     * Cleanup must NEVER break the application.
     */
    console.warn(
      "Jwan retention: notifications skipped:",
      error
    );

    return {
      ok: false,
      found: 0,
      deleted: 0,
      error
    };
  }
}

/* =========================================================
 * NEGOTIATION MESSAGES
 *
 * IMPORTANT:
 * We first find old messages.
 * Then we inspect their parent negotiation.
 *
 * We delete ONLY when:
 * - negotiation status is closed OR agreed
 * - negotiation updatedAt is older than 30 days
 *
 * Open negotiations are NEVER deleted.
 * ========================================================= */

export async function cleanupNegotiationMessages() {
  const user = auth.currentUser;

  if (!user) {
    return {
      ok: true,
      skipped: true,
      reason: "not-authenticated",
      deleted: 0
    };
  }

  try {
    const q = query(
      collectionGroup(db, "messages"),
      where(
        "createdAt",
        "<",
        cutoffTimestamp(
          RETENTION.negotiationDays
        )
      ),
      limit(MAX_DELETE_PER_RUN)
    );

    const snap = await getDocs(q);

    let deleted = 0;

    for (const item of snap.docs) {
      try {
        const data = item.data();

        if (!data?.orderId) {
          continue;
        }

        /*
         * Make sure this is actually:
         * priceNegotiations/{orderId}/messages/{id}
         */
        const path = item.ref.path;

        if (
          !path.startsWith(
            "priceNegotiations/"
          ) ||
          !path.includes(
            "/messages/"
          )
        ) {
          continue;
        }

        /*
         * Parent:
         * priceNegotiations/{orderId}
         */
        const negotiationRef =
          item.ref.parent.parent;

        if (!negotiationRef) {
          continue;
        }

        const negotiationSnap =
          await getDoc(negotiationRef);

        if (!negotiationSnap.exists()) {
          continue;
        }

        const negotiation =
          negotiationSnap.data();

        /*
         * NEVER delete an open negotiation.
         */
        if (
          negotiation.status !== "closed" &&
          negotiation.status !== "agreed"
        ) {
          continue;
        }

        /*
         * We require the negotiation itself
         * to be older than the retention period.
         */
        const updatedAt =
          valueToMillis(
            negotiation.updatedAt
          );

        if (
          !updatedAt ||
          updatedAt >=
            cutoffMillis(
              RETENTION.negotiationDays
            )
        ) {
          continue;
        }

        /*
         * Only a participant can clean
         * their negotiation messages.
         *
         * This prevents arbitrary users from
         * deleting another user's negotiation.
         */
        const orderRef =
          doc(
            db,
            "orders",
            data.orderId
          );

        const orderSnap =
          await getDoc(orderRef);

        if (!orderSnap.exists()) {
          continue;
        }

        const order =
          orderSnap.data();

        const isParticipant =
          order.customerId === user.uid ||
          order.driverId === user.uid;

        if (!isParticipant) {
          continue;
        }

        await deleteDoc(item.ref);

        deleted++;

      } catch (error) {
        console.warn(
          "Jwan retention: negotiation message skipped:",
          item.id,
          error
        );
      }
    }

    return {
      ok: true,
      found: snap.size,
      deleted
    };

  } catch (error) {
    console.warn(
      "Jwan retention: negotiation cleanup skipped:",
      error
    );

    return {
      ok: false,
      found: 0,
      deleted: 0,
      error
    };
  }
}

/* =========================================================
 * MAIN
 * ========================================================= */

export async function runJwanDataRetention({
  dryRun = false
} = {}) {

  console.log(
    "Jwan retention: starting..."
  );

  const result = {
    ai: {
      deleted: 0
    },
    notifications: {
      deleted: 0
    },
    negotiations: {
      deleted: 0
    }
  };

  if (dryRun) {
    console.log(
      "Jwan retention: DRY RUN"
    );

    return result;
  }

  /*
   * AI is localStorage and costs
   * nothing from Firebase quota.
   */
  result.ai =
    cleanupAIChats();

  /*
   * Firestore cleanup.
   * Each subsystem is isolated.
   */
  result.notifications =
    await cleanupNotifications();

  result.negotiations =
    await cleanupNegotiationMessages();

  console.log(
    "Jwan retention: completed",
    result
  );

  return result;
}

/* =========================================================
 * START ONCE
 * ========================================================= */

let started = false;

export async function startJwanDataRetention() {
  if (started) {
    return;
  }

  started = true;

  try {
    await runJwanDataRetention();
  } catch (error) {
    console.warn(
      "Jwan retention: automatic cleanup failed:",
      error
    );
  }
}
