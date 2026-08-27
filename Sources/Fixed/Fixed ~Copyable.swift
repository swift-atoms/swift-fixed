public import Index
public import Storage

extension __Fixed where S: Store.Ledgered.`Protocol` & ~Copyable {

    @inlinable
    public var startIndex: Index<S.Element> { .zero }

    @inlinable
    public var endIndex: Index<S.Element> { Index(count) }

    @inlinable
    public func index(after i: Index<S.Element>) -> Index<S.Element> {
        i.advanced(by: .one)
    }

    @inlinable
    public func index(before i: Index<S.Element>) -> Index<S.Element> {
        precondition(i.rawValue > 0, "Fixed.index(before:) called on the start index")
        return Index(i.rawValue - 1)
    }
}

extension __Fixed where S: Store.Ledgered.`Protocol` & ~Copyable {

    @inlinable
    public var count: Index<S.Element>.Count { store.initialization.count }

    @inlinable
    public var isEmpty: Bool { store.initialization.isEmpty }

    @inlinable
    public var capacity: Index<S.Element>.Count { store.capacity }

    @inlinable
    public var freeCapacity: Index<S.Element>.Count {
        store.capacity.subtracting(saturating: store.initialization.count)
    }
}

extension __Fixed where S: Store.Ledgered.`Protocol` & ~Copyable {

    @inlinable
    public subscript(_ index: Index<S.Element>) -> S.Element {
        _read {
            precondition(index < endIndex, "Index out of bounds")
            yield store[index]
        }
        _modify {
            precondition(index < endIndex, "Index out of bounds")
            store.unshare()
            yield &store[index]
        }
    }

    @inlinable
    public func withElement<R>(
        at index: Index<S.Element>,
        _ body: (borrowing S.Element) -> R
    ) -> R {
        precondition(index < endIndex, "Index out of bounds")
        return body(store[index])
    }
}

extension __Fixed where S: Store.Ledgered.`Protocol` & ~Copyable, S.Element: Copyable {

    @inlinable
    public func element(at index: Index<S.Element>) -> S.Element? {
        guard index < endIndex else { return nil }
        return store[index]
    }

    @inlinable
    public func element(
        at base: Index<S.Element>,
        offsetBy offset: Int
    ) -> S.Element? {
        let rawValue: UInt
        if offset >= 0 {
            let (result, overflow) = base.rawValue.addingReportingOverflow(UInt(offset))
            guard !overflow else { return nil }
            rawValue = result
        } else {
            let magnitude = offset.magnitude
            guard magnitude <= base.rawValue else { return nil }
            rawValue = base.rawValue - magnitude
        }
        guard rawValue < count.rawValue else { return nil }
        let newIndex = Index<S.Element>(rawValue)
        return store[newIndex]
    }
}

extension __Fixed where S: Store.Ledgered.`Protocol` & ~Copyable {

    @inlinable
    public mutating func swap(at i: Index<S.Element>, with j: Index<S.Element>) {
        precondition(
            i < endIndex && j < endIndex,
            "Index out of bounds"
        )
        guard i != j else { return }
        store.unshare()

        let tail = Index<S.Element>(count.subtracting(saturating: .one))
        var carry = store.move(at: tail)
        if i == tail {
            Swift.swap(&carry, &store[j])
        } else if j == tail {
            Swift.swap(&carry, &store[i])
        } else {
            Swift.swap(&carry, &store[i])
            Swift.swap(&carry, &store[j])
            Swift.swap(&carry, &store[i])
        }
        store.initialize(at: tail, to: carry)
    }
}
