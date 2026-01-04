#!/bin/bash

# VoiceOverDemo Install Script
# Usage: ./install_device.sh

SCHEME="VoiceOverDemo"
PROJECT="VoiceOverDemo.xcodeproj"
BUNDLE_ID="com.voiceoverdemo.VoiceOverDemo"

echo "🔍 Connecting to devices..."
# Get Legacy UDID for xcodebuild
DEVICE_UDID=$(xcodebuild -scheme "$SCHEME" -showdestinations | grep "platform:iOS," | grep -v "simulator" | grep -v "Any iOS Device" | head -n 1 | grep -oE 'id:[^,]+' | cut -d: -f2)

# Get CoreDevice UUID for devicectl
DEVICE_UUID=$(xcrun devicectl list devices | grep "iPhone" | grep -E "available|connected" | grep -oE '[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}' | head -n 1)

if [ -z "$DEVICE_UDID" ] || [ -z "$DEVICE_UUID" ]; then
    echo "❌ No available iPhone found. Please connect your device."
    echo "Check 'xcrun devicectl list devices' for details."
    exit 1
fi

echo "📱 Found iPhone with ID: $DEVICE_UDID (Legacy) / $DEVICE_UUID (CoreDevice)"

echo "🛠 Building $SCHEME for device..."
# -allowProvisioningUpdates allows Xcode to try and fix signing using the logged-in account
xcodebuild -project "$PROJECT" \
           -scheme "$SCHEME" \
           -configuration Debug \
           -destination "platform=iOS,id=$DEVICE_UDID" \
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

echo "🚀 Installing $SCHEME to device ($DEVICE_UUID)..."
xcrun devicectl device install app --device "$DEVICE_UUID" "$APP_PATH"

if [ $? -eq 0 ]; then
    echo "✅ Installation successful!"
    
    echo "🚀 Launching $BUNDLE_ID on device..."
    xcrun devicectl device process launch --device "$DEVICE_UUID" "$BUNDLE_ID"
else
    echo "❌ Installation failed."
    exit 1
fi
