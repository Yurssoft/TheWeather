// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "ImageManager",
    platforms: [.iOS("15.0")],
    products: [
        .library(
            name: "ImageManager",
            targets: ["ImageManager"]),
    ],
    dependencies: [
         .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.0.0"),
    ],
    targets: [
        .target(
            name: "ImageManager",
            dependencies: ["Kingfisher"]),
        .testTarget(
            name: "ImageManagerTests",
            dependencies: ["ImageManager"]),
    ]
)
