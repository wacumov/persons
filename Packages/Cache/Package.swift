// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Cache",
    platforms: [.iOS(.v13), .macOS(.v10_15), .tvOS(.v13)],
    products: [
        .library(
            name: "Cache",
            targets: ["Cache"]
        ),
    ],
    targets: [
        .target(
            name: "Cache"),
        .testTarget(
            name: "CacheTests",
            dependencies: ["Cache"]
        ),
    ]
)
