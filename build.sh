#!/usr/bin/env bash
# Gradle-free build of the same sources: aapt2 -> javac -> d8 -> zipalign -> apksigner.
# Handy for a quick local APK when no Android Gradle Plugin is available.
# F-Droid itself will use ./gradlew assembleRelease instead.
#
# Needs: JDK 17, Android build-tools 34+, a platform android.jar (API 35).
set -euo pipefail

SDK="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-$HOME/Android/Sdk}}"
BT="${BUILD_TOOLS:-$SDK/build-tools/35.0.0}"
PLATFORM_JAR="${PLATFORM_JAR:-$SDK/platforms/android-35/android.jar}"

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MAIN="$ROOT/app/src/main"
OUT="$ROOT/tools/build"
rm -rf "$OUT"
mkdir -p "$OUT/gen" "$OUT/classes" "$OUT/dex"

echo "== manifest (inject package for aapt2) =="
sed 's|<manifest xmlns:android="http://schemas.android.com/apk/res/android"|& package="com.gemmy.overlay"|' \
  "$MAIN/AndroidManifest.xml" > "$OUT/AndroidManifest.xml"

echo "== aapt2 compile + link =="
"$BT/aapt2" compile --dir "$MAIN/res" -o "$OUT/res.zip"
"$BT/aapt2" link -o "$OUT/base.apk" -I "$PLATFORM_JAR" \
  --manifest "$OUT/AndroidManifest.xml" --java "$OUT/gen" \
  --min-sdk-version 26 --target-sdk-version 35 \
  --version-code 1 --version-name 1.0 --auto-add-overlay "$OUT/res.zip"

echo "== javac =="
javac --release 11 -classpath "$PLATFORM_JAR" -d "$OUT/classes" \
  $(find "$MAIN/java" "$OUT/gen" -name '*.java')

echo "== d8 =="
JAVA_TOOL_OPTIONS="-Xmx700m -XX:CompressedClassSpaceSize=64m -XX:ReservedCodeCacheSize=64m" \
  "$BT/d8" -JXmx700m --lib "$PLATFORM_JAR" --min-api 26 --release --output "$OUT/dex" \
  $(find "$OUT/classes" -name '*.class')

echo "== package + align =="
cp "$OUT/base.apk" "$OUT/unsigned.apk"
(cd "$OUT/dex" && zip -q -X "$OUT/unsigned.apk" classes.dex)
"$BT/zipalign" -f -p 4 "$OUT/unsigned.apk" "$OUT/aligned.apk"

echo "== sign with a local debug key (never commit this key) =="
KS="$OUT/local.keystore"
keytool -genkeypair -keystore "$KS" -storepass gemmy123 -keypass gemmy123 \
  -alias gemmy -keyalg RSA -keysize 2048 -validity 10000 \
  -dname "CN=Gemmy, O=Gemmy, C=IN" >/dev/null 2>&1
JAVA_TOOL_OPTIONS="-XX:MaxMetaspaceSize=96m -XX:ReservedCodeCacheSize=32m" \
  "$BT/apksigner" -JXmx320M sign --ks "$KS" --ks-pass pass:gemmy123 --key-pass pass:gemmy123 \
  --ks-key-alias gemmy --min-sdk-version 26 --out "$OUT/gemmy.apk" "$OUT/aligned.apk"

ls -lh "$OUT/gemmy.apk"
echo "BUILD OK"
