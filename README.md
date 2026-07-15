# IPA Signer

A professional iOS IPA signing application built with Swift and CMake. Sign and configure iOS applications with ease.

## Features

- 🔐 Sign IPA files with certificates
- 📱 Inject provisioning profiles
- 🏗️ Built with Swift 5.9+
- 🔧 CMake build system
- 🎨 Modern SwiftUI interface
- ⚡ Fast and reliable

## Project Structure

```
.
├── CMakeLists.txt              # CMake build configuration
├── Package.swift               # Swift Package manifest
├── Info.plist                  # App info configuration
├── build.swift                 # Build script
├── Sources/
│   ├── Main.swift              # App entry point
│   └── IPASigner/
│       ├── IPASignerApp.swift   # App configuration
│       ├── ContentView.swift    # Main UI
│       ├── Views/
│       │   ├── SigningView.swift        # IPA signing interface
│       │   └── SettingsView.swift       # Settings interface
│       ├── Models/
│       │   ├── IPAFile.swift           # IPA file model
│       │   └── SigningConfig.swift     # Signing configuration
│       ├── Services/
│       │   ├── IPASigningService.swift  # Core signing logic
│       │   └── CertificateManager.swift # Certificate handling
│       └── Utilities/
│           └── FileHandler.swift        # File operations
└── README.md                   # This file
```

## Building

### Using CMake

```bash
mkdir build
cd build
cmake ..
cmake --build . --config Release
```

### Using Swift

```bash
swift build -c release
```

### Using Build Script

```bash
chmod +x build.swift
./build.swift
```

## Usage

1. Launch the IPA Signer application
2. Select an IPA file to sign
3. Choose a certificate from your keychain
4. Select a provisioning profile
5. Click "Sign IPA" to begin the signing process
6. The signed IPA will be saved to your output directory

## Requirements

- macOS 13.0 or later
- iOS 13.0 or later
- Swift 5.9 or later
- CMake 3.21 or later
- Xcode Command Line Tools

## Dependencies

- Foundation
- SwiftUI
- Security
- CommonCrypto

## Configuration

### App Settings

- **Output Directory**: Specify where signed IPAs are saved
- **Auto-save**: Automatically save signed IPAs
- **Debug Logging**: Enable detailed logging for troubleshooting

## Technical Details

### IPA Signing Process

1. Extract IPA (ZIP archive)
2. Parse app metadata
3. Replace provisioning profile
4. Update code signatures
5. Repackage as signed IPA

### Certificate Management

- Integrates with macOS Keychain
- Supports code signing certificates
- Automatic certificate discovery

### Provisioning Profile Handling

- Loads profiles from ~/Library/MobileDevice/Provisioning Profiles
- Validates profile compatibility
- Injects profiles into signed IPA

## Architecture

The application follows a modular architecture:

- **Views**: SwiftUI interfaces for user interaction
- **Services**: Core business logic (signing, certificates)
- **Models**: Data structures for IPAs and configurations
- **Utilities**: Helper functions for file operations

## Security Considerations

- All signing operations use Keychain APIs
- Certificates are never stored in memory unnecessarily
- Temporary files are cleaned up after signing
- Supports iOS app security standards

## Limitations

- iOS 13.0+ apps only
- Requires valid signing certificates
- Provisioning profiles must be valid

## Future Enhancements

- [ ] Batch signing support
- [ ] Profile creation wizard
- [ ] Mobile app version
- [ ] Advanced code signature options
- [ ] App Store optimization tools

## License

MIT License - See LICENSE file for details

## Support

For issues and feature requests, please create an issue on GitHub.

## Contributing

Contributions are welcome! Please follow the existing code style and submit pull requests.

---

**IPA Signer** - Professional iOS Application Signing
