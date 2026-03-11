## Copilot / AI Agent Instructions for this repo

Purpose: Help an AI coding agent be immediately productive in this Flutter multi-platform app.

- **Big picture:** This is a Flutter application (see [pubspec.yaml](pubspec.yaml)) with platform hosts for Android, iOS, Windows, macOS, Linux. The Dart entrypoint is `lib/main.dart` and UI + app logic lives under `lib/`. Platform-specific glue and generated plugin registrants exist under each platform folder, e.g. `linux/flutter/generated_plugin_registrant.*`, `windows/flutter/generated_plugin_registrant.*`, and `ios/Runner/GeneratedPluginRegistrant.*`.

- **Why this structure:** The project follows the standard Flutter multi-platform template. Platform folders contain host runners and any native code; the app code (Dart) is the single source of truth for app behavior.

- **Key files to inspect:**
  - [pubspec.yaml](pubspec.yaml): dependencies and Flutter config.
  - [lib/main.dart](lib/main.dart): app entrypoint and primary widget tree.
  - [analysis_options.yaml](analysis_options.yaml): lint rules and style guidance.
  - [test/widget_test.dart](test/widget_test.dart): example test harness.
  - Android: `android/app/build.gradle.kts` and `android/gradle.properties` — project uses Gradle Kotlin DSL.

- **Build & run workflows (concrete commands):**
  - Fetch deps: `flutter pub get` (run from repo root).
  - Run on a connected device or desktop: `flutter run` or `flutter run -d windows` / `-d linux` / `-d macos` / `-d chrome`.
  - Build artifacts:
    - Android APK: `flutter build apk` (or use `./gradlew` in `android/` for custom Gradle tasks).
    - Windows exe: `flutter build windows`.
    - iOS (mac only): `flutter build ios`.
  - Tests: `flutter test` (runs `test/` suite).
  - Lint/analyze: `flutter analyze` and `dart format .`.

- **Project-specific conventions & patterns:**
  - Keep Dart app code inside `lib/`. Minimal/no native code unless adding platform integrations.
  - Generated plugin registrant files are authoritative for native plugin wiring — do not hand-edit generated files; instead, add plugin deps to `pubspec.yaml` and re-run `flutter pub get`.
  - Android uses Kotlin DSL (`.kts`) in Gradle files; prefer invoking Gradle via `gradlew` on CI/Windows to avoid environment mismatch.
  - `flutter_lints` is enabled via `dev_dependencies` and `analysis_options.yaml` — follow the configured rules.

- **Integration points to watch for:**
  - Platform channels / native APIs: search the repo for `MethodChannel` or platform-specific code in `windows/runner`, `linux/runner`, `ios/Runner`, `macos/Runner` before making changes that touch native behavior.
  - Generated files: `**/generated_plugin_registrant.*` exist for multiple platforms — they reflect installed plugins.

- **When changing build files or native code:**
  - After modifying Gradle or native host code, run a full clean build: `flutter clean` then `flutter pub get` then the appropriate `flutter build` command.
  - For Android CI or Windows developer machines, prefer `android/gradlew.bat assembleDebug` (Windows) or `android/gradlew assembleDebug` (Unix) when reproducing Gradle issues.

- **Testing & debugging tips specific to this repo:**
  - `test/widget_test.dart` is a starting point; run with `flutter test test/widget_test.dart` to iterate quickly.
  - Hot reload works for UI changes in `lib/` when running with `flutter run` — use it to keep state while iterating.

- **Safe editing practices for AI agents:**
  - Avoid editing generated files in `**/generated_plugin_registrant.*` or files under `ios/Flutter/ephemeral/` and other ephemeral/generated folders.
  - When making code changes, run `flutter analyze` and `flutter test` locally (or ask the user to run them) to verify.

- **Useful grep patterns for discovery:**
  - Find native channel usage: `grep -R "MethodChannel" -n .`
  - Find generated plugin registrants: `grep -R "generated_plugin_registrant" -n .`

If anything here is unclear or you'd like more detail (CI steps, code owner contacts, or preferred commit message format), tell me which section to expand and I will update this file.
