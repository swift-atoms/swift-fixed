public import Buffer
public import Index
public import Storage

@_documentation(visibility: public)
@frozen
public struct __Fixed<S: ~Copyable>: ~Copyable {

    @usableFromInline
    package var store: S
}

public typealias Fixed<S: ~Copyable> = __Fixed<S>

extension __Fixed: Copyable where S: Copyable {}

extension __Fixed: Sendable where S: Sendable & ~Copyable {}

extension __Fixed where S: Store.Ledgered.`Protocol` & ~Copyable {

    @inlinable
    public init(store: consuming S) {
        precondition(
            store.initialization.count == store.capacity,
            "Fixed requires an always-full store"
        )
        self.store = store
    }
}
