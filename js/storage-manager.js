// =========================================================
// JWAN STORAGE MANAGER
// Automatic provider failover.
//
// Usage:
//   import { uploadJwanFile } from "./storage-manager.js";
//   const result = await uploadJwanFile(file, { folder: "uploads" });
//
// The returned object contains:
//   provider
//   key
//   url
//   size
// =========================================================

import { auth } from "./firebase-config.js";
import {
  JWAN_STORAGE_CONFIG,
  getEnabledStorageProviders
} from "./storage-config.js";

const GB = 1_000_000_000;

function cleanSegment(value) {
  return String(value || "")
    .trim()
    .replace(/[^a-zA-Z0-9._-]/g, "_")
    .slice(0, 120);
}

function makeObjectKey(file, folder = "uploads") {
  const safeFolder = cleanSegment(folder || "uploads") || "uploads";
  const original = cleanSegment(file?.name || "file.bin") || "file.bin";
  const random =
    globalThis.crypto?.randomUUID?.() ||
    `${Date.now()}-${Math.random().toString(36).slice(2)}`;

  return `jwan/${safeFolder}/${Date.now()}-${random}-${original}`;
}

function isSafeForQuota(provider, fileSize) {
  const quota = Number(provider.quotaBytes || 0);

  if (!quota) {
    return true;
  }

  // We deliberately stop before the real quota.
  const safeLimit =
    quota * Number(JWAN_STORAGE_CONFIG.safetyRatio || 0.90);

  // We do not know authoritative usage unless the provider
  // exposes it. Uploading remains allowed; provider failures
  // will trigger failover automatically.
  return fileSize <= safeLimit;
}

async function getFirebaseIdToken() {
  const user = auth?.currentUser;

  if (!user) {
    throw new Error("يجب تسجيل الدخول قبل رفع الملف.");
  }

  return user.getIdToken();
}

async function uploadToSupabase(provider, file, key) {
  if (
    !provider.projectUrl ||
    !provider.anonKey ||
    !provider.bucket
  ) {
    throw new Error("Supabase غير مهيأ بعد.");
  }

  const token = await getFirebaseIdToken();

  // NOTE:
  // The Supabase endpoint is intentionally disabled by default.
  // Firebase Auth tokens are not Supabase Auth tokens.
  // Use the Cloudflare Worker adapter for secure production
  // failover unless you explicitly add a Supabase-auth bridge.

  throw new Error(
    "Supabase يحتاج طبقة وسيطة آمنة مع Firebase Auth قبل تفعيله."
  );
}

async function uploadToR2(provider, file, key) {
  if (!provider.workerEndpoint) {
    throw new Error("Cloudflare R2 Worker غير مهيأ بعد.");
  }

  const token = await getFirebaseIdToken();

  const endpoint =
    provider.workerEndpoint.replace(/\/+$/, "") + "/upload";

  const response = await fetch(endpoint, {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${token}`,
      "X-Jwan-Key": key,
      "Content-Type": file.type || "application/octet-stream"
    },
    body: file
  });

  if (!response.ok) {
    let message = `R2 upload failed (${response.status})`;

    try {
      const data = await response.json();
      if (data?.error) {
        message = String(data.error);
      }
    } catch (_) {
      // keep fallback message
    }

    throw new Error(message);
  }

  return await response.json();
}

const adapters = {
  "supabase": uploadToSupabase,
  "cloudflare-r2": uploadToR2
};

export async function uploadJwanFile(file, options = {}) {
  if (!(file instanceof Blob)) {
    throw new Error("الملف المرسل غير صالح.");
  }

  if (!file.size) {
    throw new Error("الملف فارغ.");
  }

  const providers = getEnabledStorageProviders();

  if (!providers.length) {
    throw new Error(
      "لا يوجد Storage Provider مفعّل حاليًا."
    );
  }

  const key = makeObjectKey(file, options.folder);

  const errors = [];

  for (const provider of providers) {
    try {
      if (!isSafeForQuota(provider, file.size)) {
        errors.push(
          `${provider.id}: حجم الملف يتجاوز حد الأمان`
        );
        continue;
      }

      const adapter = adapters[provider.id];

      if (typeof adapter !== "function") {
        errors.push(`${provider.id}: adapter غير موجود`);
        continue;
      }

      const result = await adapter(provider, file, key);

      return {
        ok: true,
        provider: provider.id,
        providerName: provider.name,
        key,
        size: file.size,
        ...result
      };

    } catch (error) {
      console.warn(
        `Jwan Storage fallback: ${provider.id}`,
        error
      );

      errors.push(
        `${provider.id}: ${error?.message || "فشل الرفع"}`
      );
    }
  }

  throw new Error(
    "تعذر حفظ الملف في جميع مخازن جوان.\n" +
    errors.join("\n")
  );
}

export async function getStorageHealth() {
  const providers = getEnabledStorageProviders();

  const result = [];

  for (const provider of providers) {
    const item = {
      id: provider.id,
      name: provider.name,
      enabled: provider.enabled,
      healthy: false
    };

    try {
      if (provider.id === "cloudflare-r2") {
        if (!provider.workerEndpoint) {
          throw new Error("Worker endpoint غير موجود");
        }

        const token = await getFirebaseIdToken();

        const response = await fetch(
          provider.workerEndpoint.replace(/\/+$/, "") + "/health",
          {
            headers: {
              "Authorization": `Bearer ${token}`
            }
          }
        );

        item.healthy = response.ok;
      } else {
        // Not enabled for direct client operation.
        item.healthy = false;
      }
    } catch (error) {
      item.error = error?.message || String(error);
    }

    result.push(item);
  }

  return result;
}
