# BABSIM Frontend (Flutter)

## Prerequisites

- Flutter 3.41+
- Xcode + CocoaPods
- iPhone Developer Mode enabled

## Install

```bash
cd frontend
flutter pub get
```

## Run On iPhone

```bash
cd frontend
flutter run -d <YOUR_DEVICE_ID> \
	--dart-define=API_BASE_URL=https://babsim-production.up.railway.app \
	--dart-define=GOOGLE_SERVER_CLIENT_ID=<GOOGLE_WEB_CLIENT_ID> \
	--dart-define=GOOGLE_IOS_CLIENT_ID=<GOOGLE_IOS_CLIENT_ID>
```

Notes:

- `API_BASE_URL` is optional. If omitted, the app defaults to the production API URL.
- `GOOGLE_SERVER_CLIENT_ID` is required for Google login because backend token verification checks this audience.
- `GOOGLE_IOS_CLIENT_ID` is optional but recommended for stable iOS Google Sign-In behavior.

## iOS Google Sign-In Checklist

1. In Google Cloud Console, create iOS and Web OAuth clients.
2. Use the Web client ID as `GOOGLE_SERVER_CLIENT_ID`.
3. Use the iOS client ID as `GOOGLE_IOS_CLIENT_ID`.
4. In Xcode target `Runner`, add URL Type with the reversed iOS client ID scheme.

Example URL scheme:

```text
com.googleusercontent.apps.1234567890-abcdefg
```

## Troubleshooting iPhone Deploy

If `flutter run` fails with developer disk image mount errors:

1. Disconnect/reconnect iPhone and trust this Mac again.
2. Turn off and on Developer Mode on iPhone.
3. Reopen Xcode once, select the connected device, then retry `flutter run`.
4. Prefer USB over wireless debugging for first install.

## Useful Checks

```bash
flutter doctor -v
flutter analyze
flutter build ios --simulator
```
