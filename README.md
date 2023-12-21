# Meditation Maker

An app which lets you create meditations.

---

## Run

### 1. Flutter

1. Get flutter emulator device ID using `flutter devices`. Put this in the launch.json emulator debug configuration under `deviceId`.

2. Run this command to initialize Isar DB.

   ```
   flutter pub run build_runner build
   ```

   And this to initialize riverpod... I think???

   ```
   dart run build_runner watch
   ```

3. Select the desired device in VSCode.

4. Start the flutter app using `Ctrl` + `F5`.

   1. Not sure, but I think the full command is this.

   ```
   flutter run (toolArgs) -t lib/main.dart (args)

   // OR, maybe
   dart (vmAdditionalArgs) run (toolArgs) bin/main.dart (args)
   ```

   2. (toolArgs), etc. are in `.vscode/launch.json` with `"name": "meditation_maker web debug"`.

### 2. Firebase

IGNORE STEP 1 FOR NOW.
~~

1. Initialize ADC env var

```powershell
$GOOGLE_APPLICATION_CREDENTIALS="C:\Users\daniel\AppData\Roaming\gcloud\application_default_credentials.json"
```

~~

2. Run **IN ./functions DIRECTORY**:

```powershell
npm run serve
```

3. Exit using `ctrl` + `c`. Upon exit, you may see an error with renaming the exported devdata. **You need to manually rename the `firebase-export-...` folder inside the `./functions` folder to `devdata`**. This folder is imported when starting the emulator in the package.json `serve` command.

---

## Deploy

### Firebase

```powershell
firebase deploy --only functions
```
