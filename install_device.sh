#!/bin/bash

# VoiceOverDemo Install Script
# Usage: ./install_device.sh

SCHEME="VoiceOverDemo"
PROJECT="VoiceOverDemo.xcodeproj"
BUNDLE_ID="com.voiceoverdemo.VoiceOverDemo"

echo "🔍 Connecting to devices..."
# Get the available iPhone 16 Pro UDID
DEVICE_ID=$(xcrun devicectl list devices | grep "iPhone 16 Pro" | grep -E "available|connected" | grep -oE '[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}' | head -n 1)

if [ -z "$DEVICE_ID" ]; then
    echo "❌ No available iPhone 16 Pro found. Please connect your device."
    echo "Check 'xcrun devicectl list devices' for details."
    exit 1
fi

echo "📱 Found iPhone with ID: $DEVICE_ID"

echo "🛠 Building $SCHEME for device..."
# -allowProvisioningUpdates allows Xcode to try and fix signing using the logged-in account
xcodebuild -project "$PROJECT" \
           -scheme "$SCHEME" \
           -configuration Debug \
           -destination "platform=iOS,id=$DEVICE_ID" \
           -sdk iphoneos \
           -allowProvisioningUpdates \
           -derivedDataPath ./build \
           build

if [ $? -ne 0 ]; then
    echo "❌ Build failed."
    exit 1
fi

APP_PATH="./build/Build/Products/Debug-iphoneos/$SCHEME.app"

if [ ! -d "$APP_PATH" ]; then
    echo "❌ App not found at $APP_PATH"
    exit 1
fi

echo "🚀 Installing $SCHEME to device ($DEVICE_ID)..."
xcrun devicectl device install app --device "$DEVICE_ID" "$APP_PATH"

if [ $? -eq 0 ]; then
    echo "✅ Installation successful!"
    
    echo "🚀 Launching $BUNDLE_ID on device..."
    xcrun devicectl device process launch --device "$DEVICE_ID" "$BUNDLE_ID"
else
    echo "❌ Installation failed."
    exit 1
fi
