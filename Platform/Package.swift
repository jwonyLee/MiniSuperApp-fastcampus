// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Platform",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "CombineUtil",
            targets: ["CombineUtil"]
        ),
        .library(
            name: "RIBsUtil",
            targets: ["RIBsUtil"]
        ),
        .library(
            name: "SuperUI",
            targets: ["SuperUI"]
        ),
        .library(
            name: "DefaultsStore",
            targets: ["DefaultsStore"]
        ),
        .library(
            name: "Network",
            targets: ["Network"]
        ),
        .library(
            name: "NetworkImp",
            targets: ["NetworkImp"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/CombineCommunity/CombineExt.git", from: "1.5.1"),
        .package(url: "https://github.com/DevYeom/ModernRIBs.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "CombineUtil",
            dependencies: ["CombineExt"]
        ),
        .target(
            name: "RIBsUtil",
            dependencies: ["ModernRIBs"]
        ),
        .target(
            name: "SuperUI",
            dependencies: ["RIBsUtil"]
        ),
        .target(
            name: "DefaultsStore",
            dependencies: []
        ),
        .target(
            name: "Network",
            dependencies: []
        ),
        .target(
            name: "NetworkImp",
            dependencies: ["Network"]
        ),
    ]
)
