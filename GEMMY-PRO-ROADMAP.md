# Gemmy — production hardening plan

This repository currently contains a prebuilt APK at `Gemmy-overlay.apk` plus project documentation. The documented Android source tree (`app/`), wrapper properties, and CI workflow are not present on the current `main` tree. Do not claim a verified source build until those files are restored.

## Current binary

- Existing binary: `Gemmy-overlay.apk`
- Repository path: `/Gemmy-overlay.apk`
- Reported size from GitHub: 79,086 bytes
- SHA-256 claimed by the v1.0 release notes: `2be66fde1b0908e376b321c833d8a1801fde520b5fa8228fcb47a60187bd5887`
- The digest has not been independently recomputed in this workflow. Verify it before publishing.

## Release and package layout

Keep the original APK in the repository root for backward compatibility. For a formal release, upload the verified APK as a GitHub Release asset named `Gemmy-v1.0.apk`, and retain the APK in this repository under `releases/` only after verification. Never rename an unverified or unsigned binary and imply it was rebuilt.

Recommended eventual source layout:

```text
app/
  build.gradle.kts
  src/main/AndroidManifest.xml
  src/main/java/com/gemmy/overlay/
  src/main/res/
gradle/wrapper/
  gradle-wrapper.jar
  gradle-wrapper.properties
.github/workflows/
  android-ci.yml
docs/
  privacy.html
releases/
  Gemmy-v1.0.apk
```

## Production checklist

### Build reproducibility
- Restore and commit the complete Android source tree and the Gradle wrapper.
- Pin the Gradle wrapper distribution and Android Gradle Plugin versions.
- Build with JDK 17 and a pinned Android SDK platform/build-tools version.
- Run `./gradlew clean test lint assembleRelease` in CI.
- Archive APK and mapping outputs as workflow artifacts.

### APK verification and signing
- Inspect package ID, version code/name, min/target SDK, requested permissions and signing certificate.
- Verify APK signature with `apksigner verify --verbose --print-certs`.
- Compute and publish SHA-256 from the exact release artifact.
- Keep signing keys out of git. Use encrypted GitHub Actions secrets for a release signing key, or publish a clearly labelled debug/test APK.
- Do not claim Play Store readiness from a debug-signed APK; Play distribution requires an Android App Bundle and appropriate signing setup.

### Android reliability
- Handle overlay permission revocation and Android version differences.
- Use a foreground service notification with a clear stop action and compliant service type.
- Make boot start opt-in and respect OEM background restrictions.
- Keep touch targets accessible, restore overlay position safely, and avoid screen-edge dead zones.
- Test on current Android versions and representative OEM skins.

### Privacy and security
- Request only permissions the overlay genuinely needs.
- Keep the no-network claim only if the manifest and dependency graph confirm it.
- Never log user data or include credentials in source control.
- Document overlay and boot behavior plainly in the privacy policy.

## Current limitation

The connected GitHub file APIs can write text files but cannot upload arbitrary binary build outputs to repository contents. The current APK therefore remains the existing binary already present in the repository. A fresh APK must be built from the restored source tree in a real Android build environment, then attached as a GitHub Release asset or committed using a binary-capable Git workflow.
