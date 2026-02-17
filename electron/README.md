# Lampa Electron App for macOS

This directory contains the Electron wrapper for Lampa to create a native macOS application.

## Structure

- `electron-main.js` - Main Electron process
- `preload.js` - Preload script for secure context bridge
- `package.json` - Electron dependencies and build configuration
- `entitlements.mac.plist` - macOS entitlements for app signing
- `assets/` - Application icons and resources
- `app/` - Web build files (copied during CI/CD)

## Building Locally

```bash
# Install dependencies
cd electron
npm install

# Copy web build to app folder
cp -r ../build/web/* ./app/

# Build for macOS (universal binary)
npm run build:universal

# Or build for specific architecture
npm run build:mac-arm64  # Apple Silicon
npm run build:mac-x64    # Intel
```

## Output

Built applications will be in `electron/dist/`:
- `Lampa-{version}-arm64.dmg` - DMG installer for Apple Silicon
- `Lampa-{version}-x64.dmg` - DMG installer for Intel
- `Lampa-{version}-arm64-mac.zip` - ZIP archive for Apple Silicon
- `Lampa-{version}-x64-mac.zip` - ZIP archive for Intel

## Features

- ✅ Native macOS application
- ✅ Support for external players (IINA, Movist Pro, etc.)
- ✅ Custom URL scheme handling
- ✅ Universal binary (Intel + Apple Silicon)
- ✅ DMG installer with Applications folder link
- ✅ Code signing ready
- ✅ Hardened runtime for macOS Gatekeeper

## CI/CD

The GitHub Actions workflow automatically:
1. Builds the web version
2. Copies files to `electron/app/`
3. Installs Electron dependencies
4. Builds DMG and ZIP packages
5. Uploads artifacts and creates releases
