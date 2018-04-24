// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Holmes",
    products: [
        .library(name: "Holmes", targets: ["Holmes"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Holmes", dependencies: []),
        .testTarget(name: "holmesTests", dependencies: ["Holmes"]),
    ]
)
