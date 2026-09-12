import type { CapacitorConfig } from '@capacitor/cli';

// www/ يُبنى تلقائيًا (نسخة منسوخة من ملفات الموقع الرئيسية) بواسطة
// npm run sync-web، ولا يُحفظ في git — راجع package.json و README-APK.md.
const config: CapacitorConfig = {
  appId: 'sd.jawan.delivery',
  appName: 'جوان للتوصيل',
  webDir: 'www',
  server: {
    androidScheme: 'https'
  }
};

export default config;
