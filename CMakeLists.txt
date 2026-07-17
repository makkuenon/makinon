cmake_minimum_required(VERSION 3.21)
project(IPASigner LANGUAGES Swift)

# Swift version
set(CMAKE_Swift_LANGUAGE_VERSION 5)

# iOS target configuration
set(CMAKE_SYSTEM_NAME iOS)
set(CMAKE_OSX_SYSROOT iphoneos)
set(CMAKE_OSX_DEPLOYMENT_TARGET "13.0")
set(CMAKE_XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "13.0")

# Architecture (GitHub runners do NOT support arm64e)
set(CMAKE_OSX_ARCHITECTURES "arm64")

# Enable Swift
enable_language(Swift)

# Source files
set(SOURCES
    Sources/IPASigner/IPASignerApp.swift
    Sources/IPASigner/ContentView.swift
    Sources/IPASigner/Views/SigningView.swift
    Sources/IPASigner/Views/SettingsView.swift
    Sources/IPASigner/Models/IPAFile.swift
    Sources/IPASigner/Models/SigningConfig.swift
    Sources/IPASigner/Services/IPASigningService.swift
    Sources/IPASigner/Services/CertificateManager.swift
    Sources/IPASigner/Utilities/FileHandler.swift
)

# App target
add_executable(IPASigner ${SOURCES})

# iOS app bundle settings
set_target_properties(IPASigner PROPERTIES
    MACOSX_BUNDLE TRUE
    MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/Info.plist"

    # 🔥 REQUIRED: tells Xcode this is an iOS application
    XCODE_ATTRIBUTE_PRODUCT_TYPE "com.apple.product-type.application"

    # 🔥 REQUIRED: restricts platform to iOS only (fixes SwiftDriver crash)
    XCODE_ATTRIBUTE_SUPPORTED_PLATFORMS "iphoneos"
    XCODE_ATTRIBUTE_PLATFORM_NAME "iphoneos"

    # iPhone + iPad
    XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY "1,2"

    # Bundle + signing
    XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER "com.makinon.ipasigner"
    XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "Apple Development"
)

# Frameworks
target_link_libraries(IPASigner PUBLIC
    "-framework Foundation"
    "-framework SwiftUI"
    "-framework Security"
)

# SwiftUI previews
set_target_properties(IPASigner PROPERTIES
    XCODE_ATTRIBUTE_ENABLE_PREVIEWS YES
)

# Output directory
set_target_properties(IPASigner PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
)
