# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**AkNotes** is a SwiftUI-based note-taking application for Apple platforms (iOS/macOS). The project is structured as a standard Xcode project with Swift Package Manager integration.

## Architecture

- **App Entry Point**: `AkNotesApp.swift:11` - Main app struct using SwiftUI's App protocol
- **Main UI**: `ContentView.swift:10` - Primary view container (currently displays placeholder content)
- **Testing**: Uses modern Swift Testing framework for unit tests and XCTest for UI tests

## Development Commands

### Build & Run
- **Open in Xcode**: Open `AkNotes.xcodeproj` in Xcode
- **Run**: `⌘+R` in Xcode or use the run button
- **Build**: `⌘+B` in Xcode

### Testing
- **Run all tests**: `⌘+U` in Xcode
- **Run unit tests only**: Use Test navigator in Xcode, or run AkNotesTests scheme
- **Run UI tests only**: Use AkNotesUITests scheme
- **Single test**: Click the play button next to any test function

### Project Structure
```
AkNotes/
├── AkNotes/
│   ├── AkNotesApp.swift          # App entry point
│   ├── ContentView.swift         # Main view
│   └── Assets.xcassets/          # App assets
├── AkNotesTests/                 # Unit tests (Swift Testing)
├── AkNotesUITests/              # UI tests (XCTest)
└── AkNotes.xcodeproj/           # Xcode project
```

### Key Technologies
- **SwiftUI** for UI framework
- **Swift Testing** for unit tests (modern replacement for XCTest)
- **XCTest** for UI tests
- **Xcode project** with Swift Package Manager support

### Development Notes
- Project uses Xcode's new file system synchronization (objectVersion = 77)
- Supports multiple Apple platforms (iOS, macOS, watchOS, tvOS based on availability checks)
- Uses modern Swift concurrency with async/await patterns
- Preview provider available for SwiftUI views (`ContentView.swift:22`)

### Common Tasks
- **Add new view**: Create new SwiftUI View file in AkNotes/ directory
- **Add tests**: Add test functions to AkNotesTests/ for unit tests or AkNotesUITests/ for UI tests
- **Add assets**: Add images/icons to Assets.xcassets
- **Localization**: Add Localizable.strings files for internationalization