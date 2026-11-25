# Getting Gemmy into F-Droid — step by step

F-Droid never accepts a finished APK. It clones your **source**, builds the APK on its own
build server, signs it with **F-Droid's key**, and publishes it. So the job is: make the repo
buildable and clean, then submit a build-metadata file.

This folder is already shaped for that (`app/src/main/...`, Gradle, `fastlane/`, `LICENSE`).

---

## 0. Checklist F-Droid will run through

| Requirement | Status here |
|---|---|
| Public source repo with a real FOSS licence file | `LICENSE` = GPL-3.0 (required: the mascot comes from AntiGem, which is GPL-3.0) |
| Only FOSS dependencies | none at all — no AndroidX, no Firebase, no Play Services, no trackers |
| Buildable with command-line tools on Linux | Gradle wrapper + AGP, or `tools/build.sh` (aapt2/javac/d8) |
| No prebuilt binaries or blobs | only the standard `gradle-wrapper.jar` |
| Fastlane metadata in the repo | `fastlane/metadata/android/en-US/` |
| A git tag per release matching `versionName` | tag `v1.0` for versionCode 1 / versionName 1.0 |
| App author is aware / not opposed | you are the author |

Two things F-Droid reviewers care about that are already fine: the app asks for **no
internet permission** (nothing to leak, no trackers possible) and has **no anti-features**.

---

## 1. Push the repo

```bash
cd gemmy            # this folder
git init -b main
git add .
git commit -m "Gemmy 1.0 — floating mascot overlay"
git remote add origin https://github.com/Sameer336s/gemmy.git
git push -u origin main

git tag -a v1.0 -m "Gemmy 1.0"
git push origin v1.0
```

Check that `https://github.com/Sameer336s/gemmy` opens, `LICENSE` renders as GPL-3.0, and the
tag `v1.0` exists. If your repo has a different name, change the URLs in
`fdroid/com.gemmy.overlay.yml` and in `app/build.gradle.kts` (no, that one is fine).

Build once locally to be sure the Gradle project is healthy:

```bash
./gradlew assembleRelease
# APK: app/build/outputs/apk/release/app-release-unsigned.apk
```

(`./gradlew` needs JDK 17 and Android SDK 35. If you have no SDK, the older
`tools/build.sh` still produces a signed APK with aapt2/d8 — that is only for your own
testing, F-Droid will not use it.)

---

## 2. Open a Request For Packaging (RFP)

Go to <https://gitlab.com/fdroid/rfp/-/issues/new>, pick the **Request for Packaging**
template, and paste:

```
App name: Gemmy
Package id: com.gemmy.overlay
Source code: https://github.com/Sameer336s/gemmy
Licence: GPL-3.0-only
Description: A tiny floating mascot (the AntiGem mascot) that sits on top of the
home screen and every app. Tap, drag, double-tap, long-press for a small menu.
No internet permission, no trackers, no dependencies.
Build: ./gradlew assembleRelease (Gradle 8.9, AGP 8.7.3, compileSdk 35, minSdk 26)
I am the author and I would like it included.
```

You need a GitLab account; the issue is free.

---

## 3. Open the merge request on fdroiddata (this is the fast path)

The RFP issue is a notification; the actual inclusion is a merge request against
<https://gitlab.com/fdroid/fdroiddata>.

```bash
# fork fdroiddata on GitLab first, then:
git clone https://gitlab.com/<your-gitlab-user>/fdroiddata.git
cd fdroiddata
git checkout -b com.gemmy.overlay
cp /path/to/gemmy/fdroid/com.gemmy.overlay.yml metadata/com.gemmy.overlay.yml
git add metadata/com.gemmy.overlay.yml
git commit -m "New App: com.gemmy.overlay"
git push origin com.gemmy.overlay
```

Then open an MR on `fdroid/fdroiddata` titled **`New App: Gemmy`**, and put the link to your
RFP issue in the description.

The metadata file (`fdroid/com.gemmy.overlay.yml`) explains how to build:

```yaml
Builds:
  - versionName: '1.0'
    versionCode: 1
    commit: v1.0          # the git tag you pushed
    gradle:
      - yes
```

Useful extras if the reviewer asks:

* `subdir:` — not needed here, Gradle root is the repo root.
* `output:` — only needed when you use a custom `build:` instead of `gradle:`.
* `UpdateCheckMode: Tags` + `AutoUpdateMode: Version` are already set, so future releases are
  picked up automatically when you push a new tag.

---

## 4. Watch the CI

Every MR runs a pipeline that actually builds your app inside F-Droid's buildserver image.
Green pipeline = the build works. Red = read the log, fix, push again (usually a Gradle
version, SDK level or a missing `subdir`).

You can run the same thing locally with Docker:

```bash
docker run --rm -v "$PWD":/repo -w /repo \
  registry.gitlab.com/fdroid/fdroidserver:buildserver \
  bash -c 'apt-get update && fdroid build com.gemmy.overlay'
```

and lint the metadata with:

```bash
pipx install fdroidserver
fdroid lint com.gemmy.overlay
fdroid rewritemeta com.gemmy.overlay
```

---

## 5. Review, then it appears

A packager reviews the code (licence, no blobs, no anti-features), merges, and the next
F-Droid build cycle compiles and signs Gemmy. It shows up in the F-Droid client within a
day or two of the merge. Expect **a few weeks** end-to-end for a first submission; the
queue is volunteer-run.

---

## 6. After it is in

* **Signing:** F-Droid signs with its own key, so the F-Droid build and your own APK have
  different signatures — users cannot switch between them without uninstalling. Keep the
  same `applicationId` (`com.gemmy.overlay`) forever.
* **Updates:** bump `versionCode`/`versionName` in `app/build.gradle.kts`, add
  `fastlane/metadata/android/en-US/changelogs/<versionCode>.txt`, commit, tag `v1.1`.
  `AutoUpdateMode: Version` + `UpdateCheckMode: Tags` does the rest.
* **Fastlane files** in your repo are read on every build, so description edits and new
  screenshots need no metadata change.

---

## Things that would get it rejected (all avoided here)

* Proprietary SDKs (Firebase, GMS, Crashlytics, ad networks) — none.
* Prebuilt `.jar`/`.so` blobs without source — none (wrapper jar is standard tooling).
* A licence that is not FOSS, or no licence file — GPL-3.0, matching AntiGem.
* Tracking, telemetry, "phone home" — no internet permission at all.
* A build that needs a proprietary IDE — Gradle only.

## Faster alternative: IzzyOnDroid

If you just want it installable from an F-Droid-compatible repo this week, submit to
**IzzyOnDroid** (<https://gitlab.com/IzzyOnDroid/repo>), which mirrors FOSS apps and is much
faster to review. It does not replace the F-Droid main repo, but it is a good first step and
several apps do both.
