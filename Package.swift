// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Picross",
    dependencies: [
        .package(url: "https://github.com/bbrk24/swift-cross-ui.git", revision: "6dd411cd1c288b1cd3560bb4d3d47c5d263cc428"),
    ],
    targets: [
        .executableTarget(
            name: "Picross",
            dependencies: [
                .product(name: "SwiftCrossUI", package: "swift-cross-ui"),
                .product(name: "DefaultBackend", package: "swift-cross-ui"),
            ]
        ),
    ]
)
