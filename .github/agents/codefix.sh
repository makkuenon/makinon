#!/usr/bin/env bash
set -e

echo "🔧 Xcode Fixer Agent: starting..."

# 1. Fix CMakeLists to be a Swift library instead of an app
if [ -f "makinon/CMakeLists.txt" ]; then
  echo "🛠 Patching makinon/CMakeLists.txt..."
  cat > makinon/CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.21)
project(IPASignerCore LANGUAGES Swift)

set(CMAKE_Swift_LANGUAGE_VERSION 5)

add_library(IPASignerCore STATIC
    makinon/main.swift
)

set_target_properties(IPASignerCore PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/build"
)
EOF
fi

# 2. Create App folder with minimal SwiftUI app if missing
if [ ! -d "App" ]; then
  echo "🛠 Creating App/ SwiftUI shell..."
  mkdir -p App

  cat > App/IPASignerApp.swift << 'EOF'
import SwiftUI

@main
struct IPASignerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
EOF

  cat > App/ContentView.swift << 'EOF'
import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Makinon iOS Signer")
            .padding()
    }
}
EOF

  cat > App/Info.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
 "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>IPASigner</string>
    <key>CFBundleIdentifier</key>
    <string>com.makkuenon.makinon</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
</dict>
</plist>
EOF
fi

echo "✅ Xcode Fixer Agent: finished."
