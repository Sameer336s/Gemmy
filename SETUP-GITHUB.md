# Setting up the GitHub repo (3 minutes)

This folder is a **complete git repository** — one commit, the `v1.0` tag, and GitHub Actions
already configured. You only need to create an empty repo on GitHub and push.

---

## 1. Create the repository

1. Open <https://github.com/new>.
2. Repository name: **gemmy** · Owner: **Sameer336s** · Visibility: **Public**
   (public is required for F-Droid).
3. Do **not** add a README, .gitignore or licence — the history is already here.
4. Create repository.

## 2. Push this repository

```bash
cd gemmy-github

git remote add origin https://github.com/Sameer336s/gemmy.git
git push -u origin main
git push origin v1.0
```

When git asks for a password, use a **Personal Access Token** with the `repo` scope
(GitHub → Settings → Developer settings → Personal access tokens), or set up an SSH key and
use `git@github.com:Sameer336s/gemmy.git`.

The commit and the annotated `v1.0` tag go up together, so F-Droid has a release to build.

## 3. Fill in the About box

On the repo page, click the gear next to *About*:

- **Description:** `Gemmy — the AntiGem mascot as a standalone floating overlay. A tiny cartoon buddy that sits on top of the home screen and every app. Zero dependencies, no internet permission, GPL-3.0.`
- **Topics:** `android` `overlay` `mascot` `floating` `kotlin-free` `java` `canvas` `gpl-3-0` `f-droid` `no-internet`

## 4. Check the Actions pipeline

The first push starts `.github/workflows/build.yml`:

| Job | What it does |
|---|---|
| `build` | `./gradlew assembleRelease` with JDK 17 + Android SDK 35, uploads `gemmy-release-apk` as an artifact |
| `build` → "Refuse to ship an APK that asks for the internet" | fails the run if `INTERNET` ever appears in the manifest |
| `metadata` | parses `fdroid/com.gemmy.overlay.yml` so a broken metadata file is caught before the F-Droid MR |

Download the APK from the run page (*Actions → build → Artifacts*) to check the build works.

## 5. Turn on Pages for the privacy policy

*Settings → Pages → Source: Deploy from a branch → Branch: `main`, folder `/docs` → Save.*

A minute later the policy is live at:

```
https://sameer336s.github.io/gemmy/privacy.html
```

That is the URL for the Indus Appstore console, Google Play, and anywhere else that asks.

## 6. Publish a release (recommended)

*Releases → Draft a new release →* choose tag **v1.0**, title `Gemmy 1.0`, paste the
`CHANGELOG.md` 1.0 section, attach the APK from the Actions artifact, publish.

F-Droid's metadata points `Changelog:` at this releases page, and it gives users a direct
download that does not depend on any store.

## 7. Then submit to F-Droid

Everything F-Droid needs is already in the repo. Follow `SUBMIT-TO-FDROID.md`:
open the RFP issue on `gitlab.com/fdroid/rfp`, then send the `New App: Gemmy` merge request
to `fdroiddata` with `fdroid/com.gemmy.overlay.yml` (its `Repo:` already points at
`https://github.com/Sameer336s/gemmy.git`).

## Optional: keep a GitLab mirror

The repo also carries `.gitlab-ci.yml`. To mirror: GitLab → *New project → Import project →
Repository by URL* → `https://github.com/Sameer336s/gemmy.git`, or set up
*Settings → Repository → Mirroring repositories* on either side.

## What is in the repo already

```
app/src/main/java/com/gemmy/overlay/   the toy, the overlay service, the setup screen
app/src/main/res/                      layouts, strings, icons
fastlane/metadata/android/en-US/       store listing text, icon, feature graphic
docs/privacy.html                      privacy policy (GitHub Pages)
fdroid/com.gemmy.overlay.yml           F-Droid build metadata for the fdroiddata MR
SUBMIT-TO-FDROID.md                    the full F-Droid walkthrough
CHANGELOG.md                           release notes per version code
.github/workflows/build.yml            build + no-internet check + metadata sanity
.gitlab-ci.yml                         same pipeline for a GitLab mirror
.gitlab/issue_templates/, merge_request_templates/
tools/build.sh, tools/make_icon.py     Gradle-free build, icon renderer
LICENSE                                GPL-3.0 (the mascot comes from AntiGem, GPL-3.0)
```
