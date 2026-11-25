# Gemmy — floating mascot for Android

<p align="center">
  <strong>A tiny purple companion that stays above your apps.</strong><br/>
  Lightweight • Offline-first • Open source
</p>

[![Android](https://img.shields.io/badge/Platform-Android-3DDC84?logo=android&logoColor=white)](https://developer.android.com/)
[![License: GPL-3.0](https://img.shields.io/badge/License-GPL--3.0-blue.svg)](LICENSE)
[![APK](https://img.shields.io/badge/Download-APK-7C3AED)](Gemmy-overlay.apk)

Gemmy is a standalone floating toy overlay. It is designed to sit above the home screen and other apps, with playful idle animations and simple touch interactions.

> **Repository status:** The current repository contains the prebuilt `Gemmy-overlay.apk` and project documentation. The Android source tree and Gradle wrapper configuration described below are not currently present on `main`. See [the production hardening plan](GEMMY-PRO-ROADMAP.md). A reproducible source build is not verified yet.

## Download

- **Existing APK:** [Gemmy-overlay.apk](Gemmy-overlay.apk)
- **Install:** Download the APK on your Android device, allow installation from this source, open Gemmy, grant “Display over other apps”, then tap Start floating.
- **Important:** The APK is an existing repository binary. Verify its package details, signature and SHA-256 before treating it as a production release.

## Features documented for the current app

- Floating mascot overlay over the home screen and other apps.
- Idle movement, blinking, breathing and playful animations.
- Tap, double-tap, drag and long-press interactions.
- Three mascot sizes and remembered position.
- Foreground notification with a stop action.
- Optional start on boot.
- No account or analytics described by the project documentation.

Actual behavior and Android-version compatibility should be tested on-device before release.

## Project structure

The intended Android implementation is documented as Java + Canvas with no third-party UI libraries. However, these source paths are currently missing from the tracked `main` branch:

- `app/src/main/java/com/gemmy/overlay/GemmyView.java`
- `app/src/main/java/com/gemmy/overlay/GemmyService.java`
- `app/src/main/java/com/gemmy/overlay/MainActivity.java`
- `app/src/main/AndroidManifest.xml`

The Gradle module and wrapper files must also be restored before a reproducible build can be run. Track progress in [GEMMY-PRO-ROADMAP.md](GEMMY-PRO-ROADMAP.md).

## Build

A source build is **not currently reproducible from this checkout**, because the Android app module and wrapper configuration are missing. Once restored, the intended command is:

```bash
./gradlew clean assembleRelease
```

Expected output for a standard Android Gradle project:

```text
app/build/outputs/apk/release/
```

Use JDK 17 and the project-pinned Android Gradle Plugin / SDK versions. Do not ship a debug-signed artifact as a production release.

## Security and privacy

The app requires overlay access for its core feature. Review all requested permissions and Android foreground-service behavior before installing. The project documentation states that the app does not need internet access; verify the APK manifest and dependency graph before relying on that claim.

Privacy policy: [docs/privacy.html](docs/privacy.html) (the file must be present and GitHub Pages configured before using a public policy URL).

## Releases

Release notes: [Gemmy v1.0](Gemmy-v1.0-release-notes.md)  
Changelog: [CHANGELOG.md](CHANGELOG.md)

For release-quality packaging, verify the application ID, version, signing certificate, requested permissions and SHA-256. See [GEMMY-PRO-ROADMAP.md](GEMMY-PRO-ROADMAP.md).

## Contributing

Issues and pull requests are welcome. Keep changes focused, avoid adding unnecessary permissions or dependencies, and include device/version details for Android bugs.

## License

GPL-3.0. See [LICENSE](LICENSE).
