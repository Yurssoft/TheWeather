// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "WeatherRepository",
    platforms: [.iOS("15.0")],
    products: [
        .library(
            name: "WeatherRepository",
            targets: ["WeatherRepository"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "WeatherRepository",
            dependencies: []),
        .testTarget(
            name: "WeatherRepositoryTests",
            dependencies: ["WeatherRepository"]),
    ]
)
