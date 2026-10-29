# QR Attend

QR Attend scans a college ID card's QR code on the phone and extracts a
register/roll number on-device. Student names and optional photos are stored
locally in SQLite and the app's private documents directory. No backend,
account, or internet connection is required.

## Requirements

- Flutter 3.29.0 or later (Dart 3.7 or later)
- Android SDK and Android toolchain configured in `flutter doctor`
- JDK 17 through 24 for the included Gradle 8.14 wrapper
- Android phone with a camera for physical-device scanning

## Run in VS Code

1. Install the Flutter and Dart VS Code extensions.
2. Open this project folder (`D:\QR code`) in VS Code.
3. Select an installed Flutter SDK with **Flutter: Change SDK** if prompted.
4. Run `flutter pub get` in the integrated terminal.
5. Connect an Android phone with USB debugging enabled, or start an Android
   emulator, and choose it in the VS Code device selector.
6. Press **F5** or run `flutter run`.

On the first scan of a register number, choose **Add Student** to save the
student's name and optionally select a photo. Later scans of that register
number open the saved student profile. Use **Edit** on the profile to update
the saved details. Student records and photos stay on that device.

If `flutter doctor -v` selects Java 25 or newer, configure a compatible JDK
before building (for example, JDK 21):

```powershell
flutter config --jdk-dir="C:\path\to\jdk-21"
```

You can restore Flutter's automatic JDK selection afterward with
`flutter config --jdk-dir=""`.

## Test register-number extraction

Run the parser tests:

```powershell
flutter test
```

The tests cover plain text, labeled text, both supported JSON field examples,
an unrelated URL, malformed JSON, and an empty/unreadable payload. To test the
student workflow on an Android phone:

1. Install and open the app, then tap **Scan ID Card** and scan a college ID.
2. For an unknown register number, verify that only the register number is
   shown, then tap **Add Student**.
3. Enter the student's name, optionally choose a gallery photo, and save.
4. Scan the same QR code again; the saved name and photo should appear without
   another registration prompt.
5. Scan a different, unregistered QR code and verify that no saved student's
   details appear.
6. Close and reopen the app, then scan the original QR again to verify that
   both the record and copied photo persist.

The scanner continues to display only recognized register numbers when no
matching student has been saved.

## Build APKs

From the project root:

```powershell
flutter build apk --debug
```

The debug APK is written to `build\app\outputs\flutter-apk\app-debug.apk`.
Build a release APK with:

```powershell
flutter build apk --release
```

The release APK is written to `build\app\outputs\flutter-apk\app-release.apk`.
Install the current build on a connected device with:

```powershell
flutter install
```

## Android camera permission

`android/app/src/main/AndroidManifest.xml` declares `android.permission.CAMERA`.
The operating system asks for camera permission when the scanner starts. If
permission is denied, the scanner shows a message and allows retrying after
enabling permission in Android Settings.

## Register-number formats

The extraction rules live in `lib/register_number_parser.dart`. The accepted
JSON keys are listed in `_fieldNames`; `_candidatePattern` controls the
characters and length accepted as a register number. Update these two values
to match the actual college ID format. The parser deliberately rejects URLs
and other arbitrary payloads instead of displaying them as IDs.
"# QR-code-Scanner" 
