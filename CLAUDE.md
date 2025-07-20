# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

GE Oracle is an iOS app for searching real-time Grand Exchange prices in Old School RuneScape (OSRS). This is a learning project focused on maintainable, testable, and scalable iOS development.

## Build and Test Commands

This is an Xcode project without package.json. Use Xcode or xcodebuild commands:

- **Build**: `xcodebuild -scheme GEOracle -configuration Debug`
- **Test**: `xcodebuild test -scheme GEOracle -destination 'platform=iOS Simulator,name=iPhone 15'`
- **Clean**: `xcodebuild clean -scheme GEOracle`

## Architecture

### Dependency Injection
- Uses a custom `DependencyContainer` (aliased as `DC`) for dependency management
- Register dependencies in `GEOracleApp.swift` init method
- Resolve dependencies using `DC.shared.resolve(forType: Type.self)`

### UI Architecture
- SwiftUI with MVVM pattern
- Navigation uses `NavigationStack` with `NavigationPath`

### Testing
- **Mocks**: Located in `DevelopmentAssets/Mocks/`
- **Stubs**: Located in `DevelopmentAssets/Stubs/`
- Unit tests in `GEOracleTests/`

## Development Notes

When working with this codebase:
- Follow the existing dependency injection pattern using `DC.shared`
- Use the established mock/stub pattern for testing
- Maintain the MVVM architecture for SwiftUI views
- Test files are in `GEOracleTests/` directory
