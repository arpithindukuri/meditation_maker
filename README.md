# Meditation Maker

An app which lets you create meditations.

---

## Run

### Flutter

`Ctrl` + `F5` starts the flutter app in vscode with the selected device. Command and args are in `.vscode/launch.json`

### Firebase

1. Initialize ADC env var

```powershell
$GOOGLE_APPLICATION_CREDENTIALS="C:\Users\daniel\AppData\Roaming\gcloud\application_default_credentials.json"
```

2. Run **IN ./functions DIRECTORY**:

```powershell
npm run serve
```

---

## Deploy

### Firebase

```powershell
firebase deploy --only functions
```
