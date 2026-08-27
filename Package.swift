// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-fixed",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Fixed",
            targets: ["Fixed"]
        ),
        .library(
            name: "Fixed Apple Foundation Integration",
            targets: ["Fixed Apple Foundation Integration"]
        ),
        .library(
            name: "Fixed Test Support",
            targets: ["Fixed Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-buffer.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-storage.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-index.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Fixed",
            dependencies: [
                .product(name: "Buffer", package: "swift-buffer"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Storage", package: "swift-storage"),
            ]
        ),
        .target(
            name: "Fixed Apple Foundation Integration",
            dependencies: ["Fixed"]
        ),
        .target(
            name: "Fixed Test Support",
            dependencies: ["Fixed"],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Fixed Tests",
            dependencies: [
                "Fixed",
                "Fixed Test Support",
                .product(name: "Index", package: "swift-index"),
                .product(name: "Storage", package: "swift-storage"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem
}
