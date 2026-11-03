# swift-fixed

Use this package when you need a heap-allocated column whose length is chosen once at creation and never changes, with every slot holding an element from the start, including move-only elements. Start from `Fixed<E>`, built with `init(count:initializingWith:)`, `init(repeating:count:)` or `init(capacity:initializingWith:)`. `__Fixed<S>` wraps any always-full store of your own through `init(store:)`. If the column has to hold fewer elements than its capacity, use `Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Linear.Bounded` directly. If it has to grow, use the array in swift-array.

## Laws

- A fixed column is always full: `count` equals `capacity` and `freeCapacity` is zero. `init(store:)` traps on a store that is not full. `init(capacity:initializingWith:)` traps unless the closure fills every slot of the output span.
- `init(count:initializingWith:)` calls the initializer exactly once for each index, in ascending order from zero.
- An index at or past `count` traps in the subscript, `withElement(at:_:)` and `swap(at:with:)`. `element(at:)` and `element(at:offsetBy:)` return `nil` instead, and so does an offset that would move before index zero.
- `index(after:)` saturates instead of trapping. `index(before:)` traps on the start index.
- `swap(at:with:)` with the same index twice leaves the column unchanged.
- Destroying a fixed column destroys each of its elements exactly once.
