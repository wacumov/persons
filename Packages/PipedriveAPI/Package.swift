// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "PipedriveAPI",
    platforms: [.iOS(.v13), .macOS(.v10_15), .tvOS(.v13)],
    products: [
        .library(
            name: "PipedriveAPI",
            targets: ["PipedriveAPI"]
        ),
    ],
    targets: [
        .target(
            name: "PipedriveAPI"),
        .testTarget(
            name: "PipedriveAPITests",
            dependencies: ["PipedriveAPI"]
        ),
    ]
)
