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
