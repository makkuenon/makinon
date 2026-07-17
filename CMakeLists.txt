cmake_minimum_required(VERSION 3.21)
project(IPASigner LANGUAGES Swift)

set(CMAKE_Swift_LANGUAGE_VERSION 5)

set(CMAKE_SYSTEM_NAME iOS)
set(CMAKE_OSX_SYSROOT iphoneos)
set(CMAKE_OSX_DEPLOYMENT_TARGET "13.0")
set(CMAKE_XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "13.0")

set(CMAKE_OSX_ARCHITECTURES "arm64")

enable_language(Swift)

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

add_executable(IPASigner ${SOURCES})

set_target_properties(IPASigner PROPERTIES
    MACOSX_BUNDLE TRUE
    MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/Info.plist"

    # 🔥 REQUIRED: iOS app product type
    XCODE_ATTRIBUTE_PRODUCT_TYPE "com.apple.product-type.application"

    # 🔥 REQUIRED: restrict platform to iOS only
    XCODE_ATTRIBUTE_SUPPORTED_PLATFORMS "iphoneos"
    XCODE_ATTRIBUTE_PLATFORM_NAME "iphoneos"

    # 🔥 REQUIRED: iPhone + iPad
    XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY "1,2"

    XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER "com.makinon.ipasigner"
    XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "Apple Development"
)

target_link_libraries(IPASigner PUBLIC
    "-framework Foundation"
    "-framework SwiftUI"
    "-framework Security"
)

set_target_properties(IPASigner PROPERTIES
    XCODE_ATTRIBUTE_ENABLE_PREVIEWS YES
)

set_target_properties(IPASigner PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
)
