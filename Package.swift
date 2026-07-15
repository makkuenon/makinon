// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "IPASigner",
    platforms: [
        .macOS(.v13),
        .iOS(.v13)
    ],
    dependencies: [
        // Add dependencies here if needed
    ],
    targets: [
        .executableTarget(
            name: "IPASigner",
            dependencies: [],
            path: "Sources",
            swiftSettings: [
                .unsafeFlags(["-parse-as-library"])
            ]
        )
    ]
)
