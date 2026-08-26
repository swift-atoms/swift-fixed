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

        .library(name: "Fixed Primitive", targets: ["Fixed Primitive"]),

        .library(name: "Fixed", targets: ["Fixed"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-molecules/swift-buffer.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-buffer-linear.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-span.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-storage.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-memory-allocation.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-memory-heap.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-memory-iterator.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-collection.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-index.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-iterator.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-equation.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-hash.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-tagged.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-ordinal.git",
            branch: "main"
        ),
    ],
    targets: [

        .target(
            name: "Fixed Primitive",
            dependencies: [
                .product(name: "Store Protocol", package: "swift-storage"),
                .product(name: "Buffer Protocol", package: "swift-buffer"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Buffer Primitive", package: "swift-buffer"),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear"
                ),
                .product(
                    name: "Buffer Linear Bounded Primitive",
                    package: "swift-buffer-linear"
                ),
                .product(
                    name: "Storage Contiguous",
                    package: "swift-storage"
                ),
                .product(
                    name: "Memory Allocator Primitive",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Memory Heap", package: "swift-memory-heap"),
            ]
        ),

        .target(
            name: "Fixed",
            dependencies: [
                "Fixed Primitive",
                .product(name: "Store Protocol", package: "swift-storage"),
                .product(name: "Buffer Protocol", package: "swift-buffer"),
                .product(name: "Buffer Primitive", package: "swift-buffer"),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear"
                ),
                .product(name: "Span Protocol", package: "swift-span"),
                .product(
                    name: "Storage Contiguous",
                    package: "swift-storage"
                ),
                .product(
                    name: "Memory Allocator Primitive",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Memory Heap", package: "swift-memory-heap"),
                .product(
                    name: "Memory Iterator",
                    package: "swift-memory-iterator"
                ),
                .product(
                    name: "Buffer Linear Bounded",
                    package: "swift-buffer-linear"
                ),
                .product(name: "Collection", package: "swift-collection"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Iterable", package: "swift-iterator"),
                .product(name: "Iterator Chunk", package: "swift-iterator"),
                .product(
                    name: "Equation Standard Library Integration",
                    package: "swift-equation"
                ),
                .product(
                    name: "Hash Standard Library Integration",
                    package: "swift-hash"
                ),
            ]
        ),

        .testTarget(
            name: "Fixed Tests",
            dependencies: [
                "Fixed",
                .product(
                    name: "Buffer Linear Bounded Primitive",
                    package: "swift-buffer-linear"
                ),
                .product(name: "Storage Primitive", package: "swift-storage"),
                .product(
                    name: "Tagged Standard Library Integration",
                    package: "swift-tagged"
                ),
                .product(
                    name: "Ordinal Standard Library Integration",
                    package: "swift-ordinal"
                ),
                .product(
                    name: "Buffer Test Support",
                    package: "swift-buffer"
                ),
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
