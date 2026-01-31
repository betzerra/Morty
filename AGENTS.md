# Repository Guidelines

## Project Structure & Module Organization
- `Morty/` holds the Swift source, with feature folders like `Managers/`, `Models/`, `MenuView/`, `CalendarPicker/`, and shared helpers in `Extensions/` and `Helpers/`.
- UI assets live in `Morty/Assets.xcassets`, localized resources in `Morty/Base.lproj`.
- App configuration is in `Morty/Info.plist` and entitlements in `Morty/Morty.entitlements`.
- Tests are split between `MortyTests/` (unit tests) and `MortyUITests/` (UI tests).
- Xcode project file: `Morty.xcodeproj`.

## Build, Test, and Development Commands
- Open `Morty.xcodeproj` in Xcode and run the **Morty** scheme.
- CLI build (if the scheme exists locally):
  - `xcodebuild -project Morty.xcodeproj -scheme Morty -configuration Debug`
- Run unit tests from Xcode (**Product > Test**) or via CLI:
  - `xcodebuild test -project Morty.xcodeproj -scheme Morty -destination 'platform=macOS'`

## Coding Style & Naming Conventions
- Language: Swift. Use 4-space indentation and standard Swift API naming (UpperCamelCase types, lowerCamelCase members).
- Prefer small, focused view models and helpers inside their feature folders (e.g., `MenuView/`, `Managers/`).
- Keep filenames aligned with type names (e.g., `TimeFormatterTests.swift`).

## Testing Guidelines
- Framework: XCTest but new tests should be done using Swift Testing (if possible).
- Unit tests live in `MortyTests/`, UI tests in `MortyUITests/`.
- Name tests with clear behavior focus (e.g., `testCopiesStandupMessageWhenNoMeetings`).

## Commit & Pull Request Guidelines
- Commit history shows a lightweight Conventional Commits style (`feat:`, `fix:`, `chore:`) mixed with descriptive phrases. Prefer `type: summary` when possible.
- PRs should include: a short summary, testing notes (e.g., “Ran unit tests”), and screenshots or a short GIF for UI changes.

## Configuration Tips
- This is a macOS tray app that reads Calendar data; ensure Calendar permissions are granted when testing.
