#!/usr/bin/env bash
# ينسخ ملفات الموقع من المجلد الرئيسي إلى mobile-app/www قبل بناء التطبيق،
# حتى يبقى هناك نسخة واحدة أصلية للكود (في المجلد الرئيسي) بدون تكرار يدوي.
set -e
cd "$(dirname "$0")"
rm -rf www
mkdir -p www
cp -r ../index.html ../css ../js ../pages ../assets ../manifest.webmanifest ../sw.js www/
echo "تم نسخ ملفات الموقع إلى mobile-app/www"
