#!/bin/sh
test -f rescue_my_beauty.dmg && rm rescue_my_beauty.dmg
create-dmg \
  --volname "rescue_my_beauty Installer" \
  --volicon "./assets/rescue_my_beauty_installer.icns" \
  --background "./assets/dmg_background.png" \
  --window-pos 200 120 \
  --window-size 800 530 \
  --icon-size 130 \
  --text-size 14 \
  --icon "rescue_my_beauty.app" 260 250 \
  --hide-extension "rescue_my_beauty.app" \
  --app-drop-link 540 250 \
  --hdiutil-quiet \
  "build/macos/Build/Products/Release/rescue_my_beauty.dmg" \
  "build/macos/Build/Products/Release/rescue_my_beauty.app"