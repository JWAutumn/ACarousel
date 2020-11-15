// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "ACarousel",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v11)
    ],
    products: [
        .library(
            name: "ACarousel",
            targets: ["ACarousel"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ACarousel",
            dependencies: [])
    ]
)
