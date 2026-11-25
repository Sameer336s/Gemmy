# Gemmy — floating toy overlay (standalone)

The little purple buddy from **AntiGem** (its name in the repo is **Gemmy**, from
`app/src/main/java/ai/antigem/ui/components/FloatingMascot.kt`) — pulled out of the big
coding app into a tiny standalone app that does one thing:

> Gemmy floats over the **home screen and every other app**, all the time.

No terminal, no code editor, no AI agent. Just the toy.

**Repo:** `https://github.com/Sameer336s/gemmy` · **CI:** GitHub Actions builds a release APK
on every push and tag · privacy policy at `https://sameer336s.github.io/gemmy/privacy.html`


## What is inside

| Piece | File |
|---|---|
| The toy, drawn with plain Canvas (no images, no libraries) | `app/src/main/java/com/gemmy/overlay/GemmyView.java` |
| System-wide overlay window + foreground service | `app/src/main/java/com/gemmy/overlay/GemmyService.java` |
| One setup screen (permission, size, start/stop) | `app/src/main/java/com/gemmy/overlay/MainActivity.java` |
| Auto-start after reboot | `app/src/main/java/com/gemmy/overlay/BootReceiver.java` |
| Settings storage | `app/src/main/java/com/gemmy/overlay/Prefs.java` |
| Launcher icon renderer (PIL) | `tools/make_icon.py` |
| Gradle-free build (aapt2 → javac → d8 → zipalign → apksigner) | `tools/build.sh` |
| F-Droid store listing (descriptions, changelog, icon) | `fastlane/metadata/android/en-US/` |
| F-Droid build metadata for the fdroiddata MR | `fdroid/com.gemmy.overlay.yml` |

It is **zero-dependency**: no AndroidX, no Kotlin, no Compose, no third-party libraries at all.
The APK is ~80 KB.

## How to install

1. Copy `gemmy.apk` to the phone and open it (allow "install from unknown sources").
2. Open **Gemmy** → tap **"Display over other apps: Allow"** → switch it on.
3. Come back, tap **Start floating**. Gemmy drops onto your home screen.
4. Press the home button / open any app — Gemmy stays on top.

On MIUI / HyperOS, Realme, Vivo, Oppo, OnePlus and similar skins, also enable
*"Display pop-up windows while running in background"* and set Battery usage to
*Unrestricted*, otherwise the OEM killer stops the overlay after a while.

## What Gemmy does

- **Idle:** bobs, breathes, blinks, looks around, waves, hops, spins, yawns and finally falls
  asleep after ~55 s without a touch (with a little "z").
- **Tap:** squish + hearts + a random line in a speech bubble.
- **Double tap:** spins around, sparkles.
- **Drag:** pick it up anywhere; on release it is flung with momentum and bounces off the screen edges.
  The position is remembered.
- **Long press:** small menu — **Dance / Nap (or Wake) / Hide**.
- **Size:** S / M / L on the setup screen, changes the live overlay too.
- **Notification:** "Gemmy is floating" with a Close action; the toy keeps running as a
  foreground service so Android does not kill it.
- **Start on boot** checkbox (on by default).

## Building

Standard Gradle project (no dependencies at all, so the build is quick):

```bash
./gradlew assembleRelease
# APK: app/build/outputs/apk/release/app-release-unsigned.apk
```

Needs JDK 17 and Android SDK 35. The Gradle wrapper (8.9) and AGP 8.7.3 are pinned in
`gradle/wrapper/gradle-wrapper.properties` and `build.gradle.kts`.

There is also a Gradle-free path for a quick local APK:

```bash
ANDROID_HOME=/path/to/sdk bash tools/build.sh
```

It uses aapt2, javac, d8, zipalign and apksigner directly and signs with a throwaway
debug key created inside `tools/build/` — fine for testing, never for distribution.

## Privacy policy

`docs/privacy.html` is the policy page. Turn on GitHub Pages (Settings → Pages → Deploy from a
branch → `main`, folder `/docs`) and it is live at
`https://sameer336s.github.io/gemmy/privacy.html` — paste that into every store console.

## Publishing on F-Droid

See `SUBMIT-TO-FDROID.md`: push the repo, tag `v1.0`, open an RFP issue, then send a
`New App: Gemmy` merge request to `fdroiddata` with `fdroid/com.gemmy.overlay.yml`.

## Porting notes (Compose → Canvas)

`FloatingMascot.kt` drew the body, limbs, antenna, face and particles with Compose
`DrawScope`. `GemmyView.java` keeps the same geometry and colours:

- body: gumdrop path, vertical gradient `#C9BCFF → #8F7DFF → #5B57E0`, ink outline `#2E2A6B`
- limbs `#5B52D6`, pupils `#1B1840`, cheeks `#FF8FB8`, tongue `#FF7A9A`, star `#FFD45E`
- every shape is built once per radius (`buildArt()`), the frame loop is a single
  `Handler` tick at ~60 fps (slower when resting, so it sips battery)
- `DrawScope.withTransform { }` became `canvas.save()/translate/rotate/scale/restoreToCount`
- unit-space shapes (star, heart, sparkle, "z") keep their strokes in unit space, so the
  canvas scale scales the stroke exactly like Compose does

## Permissions used

- `SYSTEM_ALERT_WINDOW` — draw over other apps (the whole point)
- `FOREGROUND_SERVICE` + `FOREGROUND_SERVICE_SPECIAL_USE` — keep the overlay alive
- `POST_NOTIFICATIONS` — the "Gemmy is floating" notification
- `RECEIVE_BOOT_COMPLETED` — optional auto-start
- `VIBRATE` — tiny haptic on poke

No internet permission, no data collection.
