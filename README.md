# Gemmy — Android Floating Mascot Overlay

<p align="center">
  <strong>A tiny animated companion that floats above your Android apps.</strong><br/>
  Lightweight • Open source • GPL-3.0
</p>

[![Android](https://img.shields.io/badge/Platform-Android-3DDC84?logo=android&logoColor=white)](https://developer.android.com/)
[![License](https://img.shields.io/badge/License-GPL--3.0-blue.svg)](LICENSE)
[![Release](https://img.shields.io/badge/Release-v1.0-7C3AED)](https://github.com/Sameer336s/Gemmy/releases)

**Gemmy** is a playful Android floating mascot / overlay app. Keep a small animated purple companion on top of your home screen and other apps. The project is intended to be lightweight, privacy-friendly and open source.

## Download

Get the available APK from [GitHub Releases](https://github.com/Sameer336s/Gemmy/releases). Open it on your Android device, allow installation from this source, grant **Display over other apps**, then tap **Start floating**.

## Features

- Floating mascot overlay above the home screen and other apps.
- Idle animations such as blinking, breathing, bobbing and playful movements.
- Touch interactions: tap, double-tap, drag and long-press menu.
- Three mascot sizes and remembered screen position.
- Foreground notification with a stop action.
- Optional start on boot.
- GPL-3.0 open-source license.

The current release notes describe no internet permission, analytics or ads. Verify the manifest and built APK before relying on security or privacy claims.

## Project status and reproducible builds

**Important:** The current `main` branch does not contain the complete Android `app/` source module or Gradle wrapper configuration. A reproducible source build has therefore not been verified from this checkout. The APK available in Releases is a prebuilt binary; it is not proof that F-Droid can build the app from source.

See:
- [Production hardening roadmap](GEMMY-PRO-ROADMAP.md)
- [F-Droid submission checklist](SUBMIT-TO-FDROID.md)
- [Release notes](Gemmy-v1.0-release-notes.md)
- [Changelog](CHANGELOG.md)

## F-Droid

Gemmy is **not yet listed on F-Droid**. Before submitting, restore the complete source project, pin the Gradle wrapper and Android build toolchain, verify all dependencies are libre/open source, build successfully in the F-Droid environment, and submit metadata to fdroiddata for review. See [SUBMIT-TO-FDROID.md](SUBMIT-TO-FDROID.md).

## License

GNU General Public License v3.0. See [LICENSE](LICENSE).

## Links

- Repository: https://github.com/Sameer336s/Gemmy
- Releases: https://github.com/Sameer336s/Gemmy/releases
- Issues: https://github.com/Sameer336s/Gemmy/issues
