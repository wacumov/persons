// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Views",
    platforms: [.iOS(.v16), .macOS(.v13), .tvOS(.v16)],
    products: [
        .library(
            name: "Views",
            targets: ["Views"]
        ),
    ],
    targets: [
        .target(
            name: "Views"),
    ]
)
