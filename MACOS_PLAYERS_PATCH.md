# macOS Players Patch

## Changes Made

This patch adds support for **Movist Pro** and **Custom Player** to Lampa on macOS.

### Modified Files:

#### 1. `src/interaction/settings/params.js`
- Added `'movist': 'Movist Pro'` to player options
- Added `'custom': '#{settings_param_player_custom}'` to player options
- Added `select('custom_player_scheme','','vlc://')` for custom URL scheme configuration

#### 2. `src/interaction/player.js` 
- Added Movist Pro URL scheme: `movist://open?url=${url}`
- Added Custom Player with configurable scheme from settings

#### 3. `src/lang/ru.js`
- Added `settings_param_player_custom: 'Кастомный плеер'`
- Added `settings_player_custom_scheme: 'URL-схема плеера'`
- Added `settings_player_custom_scheme_descr: 'Введите схему, например: vlc:// или someplayer://'`

#### 4. `src/lang/en.js`
- Added `settings_param_player_custom: 'Custom Player'`
- Added `settings_player_custom_scheme: 'Player URL Scheme'`
- Added `settings_player_custom_scheme_descr: 'Enter scheme, e.g.: vlc:// or someplayer://'`

## How to Use

### Movist Pro
Simply select "Movist Pro" from player settings. The URL scheme `movist://open?url=` will be used automatically.

### Custom Player
1. Select "Custom Player" from settings
2. Go to Player settings and find "Player URL Scheme"
3. Enter your player's URL scheme (e.g., `vlc://`, `iina://weblink?url=`, etc.)
4. The player will launch using your custom scheme

## Building

After applying this patch, rebuild Lampa:

```bash
npm install
npm run build
```

## URL Schemes Reference

- **Movist Pro**: `movist://open?url=VIDEO_URL`
- **IINA**: `iina://weblink?url=VIDEO_URL`
- **VLC**: `vlc://VIDEO_URL`
- **Infuse**: `infuse://x-callback-url/play?url=VIDEO_URL`
- **nPlayer**: `nplayer-VIDEO_URL`
