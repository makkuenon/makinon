#!/usr/bin/swift

import Foundation

// Build configuration
let buildDirectory = ".build"
let sourceDirectory = "Sources"

print("🔨 Building IPA Signer Application...")

// Create build directory
try FileManager.default.createDirectory(
    atPath: buildDirectory,
    withIntermediateDirectories: true
)

// Run Swift compiler
let process = Process()
process.executableURL = URL(fileURLWithPath: "/usr/bin/swift")
process.arguments = ["build", "-c", "release"]

do {
    try process.run()
    process.waitUntilExit()
    
    if process.terminationStatus == 0 {
        print("✅ Build completed successfully!")
        print("📦 Output: \(buildDirectory)/.build/release/IPASigner")
    } else {
        print("❌ Build failed with status: \(process.terminationStatus)")
        exit(Int32(process.terminationStatus))
    }
} catch {
    print("❌ Error running build: \(error)")
    exit(1)
}
