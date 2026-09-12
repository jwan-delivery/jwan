#!/data/data/com.termux/files/usr/bin/bash
set -e

ROOT="$(pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"

echo "===== JWAN MULTI STORAGE INSTALL ====="
echo "ROOT: $ROOT"

mkdir -p js storage-worker/src

backup() {
  local f="$1"
  if [ -f "$f" ]; then
    cp "$f" "$f.backup-storage-$STAMP"
    echo "BACKUP: $f"
  fi
}

# =========================================================
# 1) STORAGE CONFIG
# =========================================================

backup "$ROOT/js/storage-config.js"

cat > "$ROOT/js/storage-config.js" <<'EOF'
// =========================================================
// JWAN MULTI STORAGE CONFIG
// Free-first failover architecture.
// =========================================================

export const JWAN_STORAGE_CONFIG = {
  enabled: true,

  // Move away before the real quota is reached.
  safetyRatio: 0.90,

  providers: [

    // -----------------------------------------------------
    // Provider 1: Supabase Free
    // Free quota currently: 1 GB
    // -----------------------------------------------------
    {
      id: "supabase",
      name: "Supabase",
      enabled: false,

      // Replace these after creating the Supabase project.
      projectUrl: "",
      anonKey: "",
      bucket: "jwan",

      // Conservative local target.
      quotaBytes: 1_000_000_000,

      // Optional usage endpoint.
      // Can be implemented later if needed.
      usageEndpoint: ""
    },

    // -----------------------------------------------------
    // Provider 2: Cloudflare R2 through Worker
    // Free quota currently: 10 GB-month.
    // -----------------------------------------------------
    {
      id: "cloudflare-r2",
      name: "Cloudflare R2",
      enabled: false,

      // Example:
      // https://jwan-storage.YOUR-SUBDOMAIN.workers.dev
      workerEndpoint: "",

      quotaBytes: 10_000_000_000
    }
  ]
};

export function getEnabledStorageProviders() {
  return JWAN_STORAGE_CONFIG.providers.filter(p => p.enabled);
}
EOF

# =========================================================
# 2) STORAGE MANAGER
# =========================================================

backup "$ROOT/js/storage-manager.js"

cat > "$ROOT/js/storage-manager.js" <<'EOF'
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
EOF

# =========================================================
# 3) CLOUDFLARE WORKER
# =========================================================

backup "$ROOT/storage-worker/src/index.js"

cat > "$ROOT/storage-worker/src/index.js" <<'EOF'
import { jwtVerify, createRemoteJWKSet } from "jose";

const GOOGLE_JWKS = createRemoteJWKSet(
  new URL(
    "https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com"
  )
);

function corsHeaders(env) {
  const origin = env.ALLOWED_ORIGIN || "*";

  return {
    "Access-Control-Allow-Origin": origin,
    "Access-Control-Allow-Headers":
      "Authorization, Content-Type, X-Jwan-Key",
    "Access-Control-Allow-Methods":
      "GET, POST, OPTIONS",
    "Access-Control-Max-Age": "86400"
  };
}

function json(data, status = 200, env) {
  return new Response(
    JSON.stringify(data),
    {
      status,
      headers: {
        "Content-Type": "application/json; charset=utf-8",
        ...corsHeaders(env)
      }
    }
  );
}

async function requireFirebaseUser(request, env) {
  const header =
    request.headers.get("Authorization") || "";

  if (!header.startsWith("Bearer ")) {
    throw new Error("Missing Firebase ID token.");
  }

  const token = header.slice(7).trim();

  const projectId = env.FIREBASE_PROJECT_ID;

  if (!projectId) {
    throw new Error("FIREBASE_PROJECT_ID is missing.");
  }

  const verified = await jwtVerify(
    token,
    GOOGLE_JWKS,
    {
      issuer:
        `https://securetoken.google.com/${projectId}`,
      audience: projectId
    }
  );

  return verified.payload;
}

function safeKey(value) {
  return String(value || "file.bin")
    .replace(/^\/+/, "")
    .replace(/\.\./g, "")
    .replace(/[^a-zA-Z0-9/_._-]/g, "_")
    .slice(0, 500);
}

async function handleUpload(request, env) {
  const user = await requireFirebaseUser(request, env);

  const suppliedKey =
    safeKey(request.headers.get("X-Jwan-Key"));

  const filename =
    suppliedKey.replace(/^jwan\//, "");

  const key =
    `jwan/users/${user.user_id || user.sub}/${filename}`;

  if (!request.body) {
    return json(
      { error: "Empty upload body." },
      400,
      env
    );
  }

  const contentType =
    request.headers.get("Content-Type") ||
    "application/octet-stream";

  const object =
    await env.R2_BUCKET.put(
      key,
      request.body,
      {
        httpMetadata: {
          contentType
        },
        customMetadata: {
          uid: user.user_id || user.sub || ""
        }
      }
    );

  return json(
    {
      ok: true,
      provider: "cloudflare-r2",
      key,
      size: object?.size ?? null,
      url:
        `${env.PUBLIC_BASE_URL.replace(/\/+$/, "")}/file/${encodeURIComponent(key)}`
    },
    200,
    env
  );
}

async function handleUsage(request, env) {
  await requireFirebaseUser(request, env);

  let cursor;

  let totalBytes = 0;
  let objects = 0;

  do {
    const listed =
      await env.R2_BUCKET.list({
        prefix: "jwan/",
        cursor
      });

    for (const object of listed.objects) {
      totalBytes += Number(object.size || 0);
      objects += 1;
    }

    cursor = listed.truncated
      ? listed.cursor
      : undefined;

  } while (cursor);

  return json(
    {
      ok: true,
      provider: "cloudflare-r2",
      totalBytes,
      objects
    },
    200,
    env
  );
}

async function handleFile(request, env, key) {
  // Public serving can be enabled by setting PUBLIC_FILES=true.
  // Sensitive/private files should later use signed/authenticated
  // download handling instead.
  if (env.PUBLIC_FILES !== "true") {
    await requireFirebaseUser(request, env);
  }

  const object =
    await env.R2_BUCKET.get(key);

  if (!object) {
    return new Response("Not Found", {
      status: 404,
      headers: corsHeaders(env)
    });
  }

  const headers = new Headers(corsHeaders(env));

  object.writeHttpMetadata(headers);

  headers.set(
    "etag",
    object.httpEtag
  );

  return new Response(object.body, {
    headers
  });
}

export default {
  async fetch(request, env) {
    if (request.method === "OPTIONS") {
      return new Response(null, {
        headers: corsHeaders(env)
      });
    }

    const url = new URL(request.url);

    try {
      if (url.pathname === "/health") {
        await requireFirebaseUser(request, env);

        return json(
          {
            ok: true,
            provider: "cloudflare-r2"
          },
          200,
          env
        );
      }

      if (
        request.method === "POST" &&
        url.pathname === "/upload"
      ) {
        return await handleUpload(request, env);
      }

      if (
        request.method === "GET" &&
        url.pathname === "/usage"
      ) {
        return await handleUsage(request, env);
      }

      if (
        request.method === "GET" &&
        url.pathname.startsWith("/file/")
      ) {
        const key = decodeURIComponent(
          url.pathname.slice("/file/".length)
        );

        return await handleFile(
          request,
          env,
          key
        );
      }

      return json(
        { error: "Not found." },
        404,
        env
      );

    } catch (error) {
      console.error(error);

      return json(
        {
          error:
            error?.message ||
            "Storage Worker error."
        },
        500,
        env
      );
    }
  }
};
EOF

# =========================================================
# 4) WORKER PACKAGE
# =========================================================

cat > "$ROOT/storage-worker/package.json" <<'EOF'
{
  "name": "jwan-storage-worker",
  "private": true,
  "type": "module",
  "dependencies": {
    "jose": "^6.1.0"
  },
  "devDependencies": {
    "wrangler": "^4.35.0"
  },
  "scripts": {
    "deploy": "wrangler deploy",
    "dev": "wrangler dev"
  }
}
EOF

cat > "$ROOT/storage-worker/wrangler.toml" <<'EOF'
name = "jwan-storage"
main = "src/index.js"
compatibility_date = "2026-09-01"

[[r2_buckets]]
binding = "R2_BUCKET"
bucket_name = "jwan"

[vars]
FIREBASE_PROJECT_ID = "jwan-delivery-c930d-72911"
ALLOWED_ORIGIN = "https://jwan-delivery-c930d-72911.web.app"
PUBLIC_BASE_URL = "https://jwan-storage.example.workers.dev"
PUBLIC_FILES = "true"
EOF

# =========================================================
# 5) DO NOT ENABLE PROVIDERS YET
# =========================================================

echo
echo "===== INSTALLED ====="
echo "js/storage-config.js"
echo "js/storage-manager.js"
echo "storage-worker/src/index.js"
echo "storage-worker/package.json"
echo "storage-worker/wrangler.toml"

# =========================================================
# 6) FIND CURRENT UPLOAD LOCATIONS
# =========================================================

echo
echo "===== CURRENT STORAGE/UPLOAD REFERENCES ====="

grep -RIn \
  --exclude-dir=node_modules \
  --exclude-dir=.git \
  -E \
  'uploadBytes|uploadString|uploadBytesResumable|putFile|storage\.ref|firebase/storage|StorageReference|getDownloadURL|<input[^>]+type=["'\"']file' \
  . 2>/dev/null | head -150 || true

# =========================================================
# 7) JS SYNTAX CHECK
# =========================================================

echo
echo "===== JS SYNTAX ====="

if command -v node >/dev/null 2>&1; then
  node --check js/storage-config.js
  node --check js/storage-manager.js
  node --check storage-worker/src/index.js
  echo "JS SYNTAX: PASS"
else
  echo "Node غير مثبت. تخطي syntax check."
fi

echo
echo "===== DONE ====="
