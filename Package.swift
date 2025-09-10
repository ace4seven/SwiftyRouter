// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyRouter",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "SwiftyRouter",
            targets: ["SwiftyRouter"]),
    ],
    targets: [
        .target(
            name: "SwiftyRouter"
        ),
        .testTarget(
            name: "SwiftyRouterTests",
            dependencies: ["SwiftyRouter"]),
    ]
)
