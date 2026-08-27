# Fixed

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

`Fixed<S>` — an adapter that enforces the `count == capacity` invariant from construction onward, giving an always-full view over any ledgered `Store`.

---

## Quick Start

`Fixed<S>` wraps a ledgered store and proves that every slot is initialized: `count == capacity` is established at construction and preserved by the surface. There is no `append` or `remove` that could leave a hole — the only writes are in place (`subscript`, `swap`), so downstream code never has to handle the partially-filled case.

The inline store below has three slots. Initialize each slot before wrapping it as `Fixed`:

```swift
import Fixed

var store = Store.Inline<Int, 3>()
for rawValue in UInt(0)..<UInt(3) {
    let index = Index<Int>(rawValue)
    let value = 0
    store.initialize(at: index, to: value)
}

var grid = Fixed(store: store)

let first = grid.startIndex
let last = grid.index(before: grid.endIndex)
grid[first] = 10
grid[last] = 30
grid.swap(at: first, with: last)

print(grid[first])                   // 30
print(grid.count == grid.capacity)   // true — always full
print(grid.freeCapacity == .zero)    // true — no free slot
```

`Fixed` is conditionally `Copyable` and `Sendable` exactly when its backing store is, and it adds no storage of its own — the initialization ledger remains the source of truth.

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-atoms/swift-fixed.git", branch: "main")
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Fixed", package: "swift-fixed"),
    ]
)
```

The package is pre-1.0 — depend on `branch: "main"` until `0.1.0` is tagged. Requires Swift 6.4 and macOS 27 / iOS 27 / tvOS 27 / watchOS 27 / visionOS 27 (or the matching Linux / Windows toolchain).

---

## Architecture

Three library products over the `Buffer`, `Index`, and `Storage` atoms.

| Product | Target | Purpose |
|---------|--------|---------|
| `Fixed` | `Sources/Fixed/` | The generic always-full store adapter and its invariant-preserving indexed operations. |
| `Fixed Apple Foundation Integration` | `Sources/Fixed Apple Foundation Integration/` | The Foundation-facing aggregation product. |
| `Fixed Test Support` | `Tests/Support/` | Re-exports the core module for test consumers. |

Foundation is imported only by the Apple Foundation Integration target.

---

## Platform Support

| Platform | Status |
|----------|--------|
| macOS 27 | Full support |
| Linux | Full support |
| Windows | Full support |
| iOS 27 / tvOS 27 / watchOS 27 / visionOS 27 | Supported |

---

## Community

<!-- BEGIN: discussion -->
<!-- Discussion thread created at publication. -->
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
