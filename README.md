![](/assets/images/2_icon_nobg_256.png)

### Meditation Maker

A mobile app to create guided meditation audios from text.

> ###### _Built with Flutter and Firebase_

> ###### _Includes Redux, NoSQL, Serverless, Dart (OOP)_

---

# Table of Contents

- [Table of Contents](#table-of-contents)
- [Setup](#setup)
  - [1. Install Tools](#1-install-tools)
  - [2. Flutter](#2-flutter)
- [Run Locally](#run-locally)
  - [1. Run Flutter App (Android Emulator).](#1-run-flutter-app-android-emulator)
    - [Troubleshooting:](#troubleshooting)
    - [Run Web Version (DEPRECATED)](#run-web-version-deprecated)
  - [2. Run Firebase Emulator](#2-run-firebase-emulator)
    - [Persist FireStore State](#persist-firestore-state)
- [Deploy](#deploy)
  - [Firebase](#firebase)

---

# Setup

## 1. Install Tools

1. VSCode
2. Flutter
3. Android Emulator
4. Firebase CLI

## 2. Flutter

1. Set emulator ID in `.vscode/task.json` configuration.

   1. Run `flutter devices` to get flutter emulator ID. (E.g. `Galaxy_S21_Ultra_API_30`).

   2. In `task.json`, set `"command": "flutter emulators --launch Galaxy_S21_Ultra_API_30"`.

2. Set running emulator's device ID in `.vscode/launch.json` configuration.

   1. Run `flutter emulators --launch Galaxy_S21_Ultra_API_30` to start the emulator.

   2. Run `flutter devices` to get running emulator's device ID. (E.g. `emulator-5554`).

   3. In `launch.json`, in the `"configurations": ` **item** with `"name": "meditation_maker emulator debug"`, set `"deviceId": "emulator-5554"`.

---

# Run Locally

## 1. Run Flutter App (Android Emulator).

1. If you haven't done do, complete the setup as described above.

2. Start the flutter app using `ctrl`+`f5`.

### Troubleshooting:

- No supported devices found with name or id matching '`deviceId`':

  - Wait until the emulator has loaded, and run `ctrl`+`f5` again.

- If the wrong configuration runs:

  - Open the "Run and Debug" pane (`ctrl`+`shift`+`d`), select the `meditation_maker emulator debug` configuration in the dropdown, and then start it.

### Run Web Version (DEPRECATED)

Not used anymore.

1. Select the "Edge" device in VSCode. (`ctrl`+`shift`+`p` -> "Flutter: Select Device").

2. Start the flutter app using `ctrl`+`f5`.

   1. Didn't do much research, so not sure which of these two commands this runs.

      ```shell
      flutter run (toolArgs) -t lib/main.dart (args)
      ```

      ```shell
      dart (vmAdditionalArgs) run (toolArgs) bin/main.dart (args)
      ```

   2. Previously used (toolArgs), etc. are in the `.vscode/launch.json` configuration with `"name": "meditation_maker web debug"`.

## 2. Run Firebase Emulator

~~1. Initialize ADC env var~~

~~```powershell~~
~~$GOOGLE_APPLICATION_CREDENTIALS="C:\Users\daniel\AppData\Roaming\gcloud\application_default_credentials.json"~~
~~```~~
I don't think this is needed. Will check once I am working on backend again.

1. Open terminal in `./functions` directory, and run `npm run serve`.

2. When done, exit that shell using `ctrl`+`c`.

### Persist FireStore State

If you want to save the new/modifed FireStore data from the session, and have it imported during the next start:

1.  Upon exiting the firebase emulator, you may see an error with renaming the exported devdata.
2.  **Inside the `./functions` folder, manually rename the `firebase-export-...` folder to `devdata`**.
3.  This `devdata` folder is imported when starting the emulator in the package.json `serve` command.
4.  Upon exit, the CLI tool fails to rename the exported data, which is why you need to do this manually.

---

# Deploy

## Firebase

```powershell
firebase deploy --only functions
```
