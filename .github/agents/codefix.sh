#!/usr/bin/env bash
set -e

echo "🔧 Xcode Fixer Agent: starting..."

# 1. Create Core folder with Swift library files if missing
if [ ! -d "Core" ]; then
  echo "🛠 Creating Core/ Swift library..."
  mkdir -p Core

  cat > Core/IPAFile.swift << 'EOF'
import Foundation

public struct IPAFile {
    public let url: URL
    
    public init(url: URL) {
        self.url = url
    }
}
EOF

  cat > Core/SigningConfig.swift << 'EOF'
import Foundation

public struct SigningConfig {
    public let certificate: String
    
    public init(certificate: String) {
        self.certificate = certificate
    }
}
EOF

  cat > Core/IPASigningService.swift << 'EOF'
import Foundation

public final class IPASigningService {
    public init() {}
    
    public func sign(ipa: IPAFile, config: SigningConfig) {
        print("Signing \(ipa.url.lastPathComponent) with \(config.certificate)")
    }
}
EOF

  cat > Core/CertificateManager.swift << 'EOF'
import Foundation
public final class CertificateManager {
    public func load() -> String { "DeveloperCertificate" }
}
EOF

  cat > Core/FileHandler.swift << 'EOF'
import Foundation
public final class FileHandler {
    public func exists(_ url: URL) -> Bool {
        FileManager.default.fileExists(atPath: url.path)
    }
}
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
    <string>Makinon</string>
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
