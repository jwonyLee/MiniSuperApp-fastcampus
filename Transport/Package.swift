// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Transport",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "TransportHome",
            targets: ["TransportHome"]),
    ],
    dependencies: [
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "TransportHome",
            dependencies: [],
            resources: [
                .process("Resources")
            ]
        ),
    ]
)
