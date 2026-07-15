cmake_minimum_required(VERSION 3.21)
project(IPASigner LANGUAGES Swift)

# Set Swift language version
set(CMAKE_Swift_LANGUAGE_VERSION 5.9)

# Set deployment target
set(CMAKE_OSX_DEPLOYMENT_TARGET "13.0")
set(CMAKE_XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "13.0")

# Add Swift module path
list(APPEND CMAKE_MODULE_PATH "/usr/local/share/cmake/Modules")

# Enable Swift language support (native CMake support)
enable_language(Swift)

# Define source files
set(SOURCES
    Sources/Main.swift
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

# Create the executable
add_executable(IPASigner ${SOURCES})

# Set bundle identifier and signing
set_target_properties(IPASigner PROPERTIES
    MACOSX_BUNDLE TRUE
    MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/Info.plist"
    XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER "com.makinon.ipasigner"
    XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "Apple Development"
)

# Link frameworks
target_link_libraries(IPASigner PUBLIC
    "-framework Foundation"
    "-framework SwiftUI"
    "-framework Security"
    "-framework CommonCrypto"
)

# SwiftUI configuration
set_target_properties(IPASigner PROPERTIES
    XCODE_ATTRIBUTE_ENABLE_PREVIEWS YES
)

# Output settings
set_target_properties(IPASigner PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
)
