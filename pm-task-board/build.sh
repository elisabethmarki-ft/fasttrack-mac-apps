#!/bin/bash
set -e
cd "$(dirname "$0")"
APP="PM Task Board.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
swiftc -O main.swift -o "$APP/Contents/MacOS/PMTaskBoard" -framework Cocoa -framework WebKit
cp Info.plist "$APP/Contents/"
[ -d web ] && cp -R web "$APP/Contents/Resources/web"
if [ -d AppIcon.iconset ]; then iconutil -c icns AppIcon.iconset -o "$APP/Contents/Resources/AppIcon.icns"; fi
codesign --force --deep -s - "$APP"
echo built
