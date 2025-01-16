// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Networking",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "Networking",
            targets: ["Networking"]),
    ],
    dependencies: [
        .package(path: "./Logger"),
        .package(url: "https://github.com/AliSoftware/OHHTTPStubs", from: "9.1.0"),
    ],
    targets: [
        .target(
            name: "Networking",
            dependencies: [
                "Logger",
                .product(name: "OHHTTPStubs", package: "OHHTTPStubs"),
            ],
            path: "Sources"
        )
    ]
)
