# Setting up the GitLab repo (5 minutes)

This folder is a **complete git repository** — it already has a commit and the `v1.0` tag.
You only need to create an empty project on GitLab and push.

---

## 1. Create the project

1. Go to <https://gitlab.com/projects/new> → **Create blank project**.
2. Project name: `gemmy` · Project slug: `gemmy` · Visibility: **Public**.
3. **Uncheck** "Initialize repository with a README" — the history is already here.
4. Create project.

Your URLs will be:

```
https://gitlab.com/<YOUR-GITLAB-USER>/gemmy
```

## 2. Push this repository

```bash
cd gemmy-gitlab

git remote add origin https://gitlab.com/<YOUR-GITLAB-USER>/gemmy.git
git push -u origin main
git push origin v1.0
```

When git asks for a password, paste a **Personal Access Token** (not your account
password): GitLab → *Preferences → Access Tokens →* scope **write_repository**, expiry
whatever you like. Or set up an SSH key and use
`git@gitlab.com:<YOUR-GITLAB-USER>/gemmy.git`.

The commit and the annotated `v1.0` tag come along, so F-Droid has something to build from
straight away.

## 3. Check the pipeline

The first push starts `.gitlab-ci.yml`:

| Job | What it does |
|---|---|
| `build-release` | `./gradlew assembleRelease`, keeps the APK as a downloadable artifact |
| `check-no-internet-permission` | fails the pipeline if the APK ever starts requesting `INTERNET` |
| `lint-fdroid-metadata` | manual job that runs `fdroid lint` on the metadata file |
| `pages` | publishes `docs/` (the privacy policy) |

If the runner is disabled: *Settings → CI/CD → Runners →* enable instance runners.

## 4. Your privacy policy URL

After the first successful `pages` job, the policy is live at:

```
https://<YOUR-GITLAB-USER>.gitlab.io/gemmy/privacy.html
```

Put that in the Indus Appstore console (and anywhere else that asks for a policy URL).

## 5. Replace the placeholder

Two files still say `YOUR-GITLAB-USER`:

```bash
grep -rn "YOUR-GITLAB-USER" README.md fdroid/com.gemmy.overlay.yml
```

Fix them, commit, push:

```bash
git add -A
git commit -m "Point metadata at the GitLab repo"
git push
```

The file `fdroid/com.gemmy.overlay.yml` is what goes into the F-Droid `fdroiddata` merge
request — its `Repo:` must be the URL that actually serves the code.

## 6. Optional extras

- **Mirror from GitHub:** *Settings → Repository → Mirroring repositories* → add
  `https://github.com/Sameer336s/gemmy.git` as a pull mirror, so both stay identical.
- **Protect `main`:** *Settings → Repository → Protected branches* → allow no direct pushes,
  require a pipeline to pass.
- **Releases:** *Deploy → Releases → New release* on tag `v1.0`, attach the APK from the
  `build-release` artifacts. F-Droid's `Changelog:` field points at this page.
- **Signing for your own releases:** generate a keystore, keep it out of the repo
  (`*.keystore` is already in `.gitignore`), and store the password in
  *Settings → CI/CD → Variables* (masked). F-Droid does not need it — F-Droid signs with
  its own key.

## What is in the repo already

```
app/src/main/java/com/gemmy/overlay/   the toy, the overlay service, the setup screen
app/src/main/res/                      layouts, strings, icons
fastlane/metadata/android/en-US/       store listing text + icon + feature graphic
docs/privacy.html                      privacy policy, published by GitLab Pages
fdroid/com.gemmy.overlay.yml           F-Droid build metadata (for the fdroiddata MR)
SUBMIT-TO-FDROID.md                    the whole F-Droid submission walkthrough
CHANGELOG.md                           release notes per version code
.gitlab-ci.yml                         build + checks + Pages
.gitlab/issue_templates/, merge_request_templates/
LICENSE                                GPL-3.0 (the mascot comes from AntiGem, GPL-3.0)
```
