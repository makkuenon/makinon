// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "Makinon",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "MakinonCore", targets: ["MakinonCore"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MakinonCore",
            dependencies: [],
            path: "Core"
        )
    ]
)
