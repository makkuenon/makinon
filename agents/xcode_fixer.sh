#!/usr/bin/env bash
set -e

echo "🔧 Xcode Fixer Agent: starting..."

# ---------------------------------------------------------
# 1. Remove Swift CLI files that break iOS builds
# ---------------------------------------------------------
echo "🗑 Removing conflicting Swift CLI files..."
rm -f main.swift
rm -f ipasign/main.swift
rm -f Sources/main.swift
rm -f */main.swift || true

# ---------------------------------------------------------
# 2. Create SwiftUI iOS app if missing
# ---------------------------------------------------------
if [ ! -d "App" ]; then
  echo "📱 Creating SwiftUI App folder..."
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
        VStack {
            Text("IPASign iOS App")
                .font(.largeTitle)
                .padding()
        }
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
    <string>IPASign</string>
    <key>CFBundleIdentifier</key>
    <string>com.makkuenon.ipasign</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
</dict>
</plist>
EOF
fi

echo "✅ Xcode Fixer Agent: finished."
