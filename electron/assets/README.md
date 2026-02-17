# Electron App Assets

## Application Icon

### Creating the macOS Icon (.icns)

You need to create an `.icns` file for the macOS application icon.

#### Using iconutil (macOS)

1. Create a folder structure:
```bash
mkdir -p icon.iconset
```

2. Generate icon sizes (from your source PNG):
```bash
sips -z 16 16     icon.png --out icon.iconset/icon_16x16.png
sips -z 32 32     icon.png --out icon.iconset/icon_16x16@2x.png
sips -z 32 32     icon.png --out icon.iconset/icon_32x32.png
sips -z 64 64     icon.png --out icon.iconset/icon_32x32@2x.png
sips -z 128 128   icon.png --out icon.iconset/icon_128x128.png
sips -z 256 256   icon.png --out icon.iconset/icon_128x128@2x.png
sips -z 256 256   icon.png --out icon.iconset/icon_256x256.png
sips -z 512 512   icon.png --out icon.iconset/icon_256x256@2x.png
sips -z 512 512   icon.png --out icon.iconset/icon_512x512.png
sips -z 1024 1024 icon.png --out icon.iconset/icon_512x512@2x.png
```

3. Convert to .icns:
```bash
iconutil -c icns icon.iconset -o icon.icns
```

4. Move to assets folder:
```bash
mv icon.icns electron/assets/
```

#### Using Online Converter

Alternatively, use an online converter:
- https://cloudconvert.com/png-to-icns
- https://anyconv.com/png-to-icns-converter/

1. Upload your source PNG (1024x1024 recommended)
2. Convert to .icns
3. Download and place in `electron/assets/icon.icns`

#### Using the Lampa Logo

You can extract the Lampa logo from:
- `public/img/logo.png` (if available)
- Or from https://github.com/yumata/lampa

### Temporary Solution

If you don't have an icon yet, the build will use Electron's default icon.
To add your icon later, just place `icon.icns` in this directory and rebuild.

### Required Files

- `icon.icns` - macOS application icon (required for DMG)
- `icon.png` - PNG version (optional, for development)

### Icon Specifications

- **Format**: ICNS (Apple Icon Image format)
- **Sizes**: 16x16, 32x32, 64x64, 128x128, 256x256, 512x512, 1024x1024
- **Source**: PNG with transparency, 1024x1024px minimum
- **Style**: Should represent the Lampa brand
