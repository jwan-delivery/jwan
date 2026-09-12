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
