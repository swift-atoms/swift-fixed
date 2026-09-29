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
            name: "Fixed Standard Library Integration",
            targets: ["Fixed Standard Library Integration"]
        ),
        .library(
            name: "Fixed Apple Foundation Integration",
            targets: ["Fixed Apple Foundation Integration"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-store.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-buffer.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-buffer-linear.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-storage.git",
            branch: "main"
        , traits: ["Memory"]),
        .package(
            url: "https://github.com/swift-molecules/swift-memory-allocation.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-memory.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-index.git",
            branch: "main"
        ),

        .package(url: "https://github.com/swift-atoms/swift-cardinal.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-ordinal.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-tagged.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Fixed",
            dependencies: [
                .product(name: "Store", package: "swift-store"),
                .product(name: "Buffer", package: "swift-buffer"),
                .product(name: "Index", package: "swift-index"),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear"
                ),
                .product(
                    name: "Buffer Linear Bounded",
                    package: "swift-buffer-linear"
                ),
                .product(
                    name: "Buffer Linear Bounded Primitive",
                    package: "swift-buffer-linear"
                ),
                .product(name: "Storage", package: "swift-storage"),
                .product(
                    name: "Memory Allocator",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Memory", package: "swift-memory"),
            ]
        ),
        .target(
            name: "Fixed Standard Library Integration",
            dependencies: ["Fixed"]
        ),
        .target(
            name: "Fixed Apple Foundation Integration",
            dependencies: [
                "Fixed",
                "Fixed Standard Library Integration",
            ]
        ),
        .testTarget(
            name: "Fixed Tests",
            dependencies: ["Fixed", .product(name: "Buffer Test Support", package: "swift-buffer")]
        ),

        .testTarget(name: "Decision Fixed Integration Tests", dependencies: ["Fixed", .product(name: "Cardinal", package: "swift-cardinal"), .product(name: "Ordinal", package: "swift-ordinal"), .product(name: "Tagged", package: "swift-tagged"), .product(name: "Index", package: "swift-index"), .product(name: "Storage", package: "swift-storage"), .product(name: "Store", package: "swift-store"), .product(name: "Buffer", package: "swift-buffer")], path: "Tests/Decision Fixed Integration Tests"),
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
