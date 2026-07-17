cmake_minimum_required(VERSION 3.21)
project(IPASignerCore LANGUAGES Swift)

set(CMAKE_Swift_LANGUAGE_VERSION 5)

# Build as a Swift static library
add_library(IPASignerCore STATIC
    Core/IPAFile.swift
    Core/SigningConfig.swift
    Core/IPASigningService.swift
    Core/CertificateManager.swift
    Core/FileHandler.swift
)

# Output directory
set_target_properties(IPASignerCore PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
)
