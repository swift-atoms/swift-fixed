import Buffer_Linear_Bounded_Primitive
import Buffer_Linear_Primitive
import Buffer
import Buffer_Test_Support
import Fixed
import Index
import Memory_Allocator
import Memory
import Ordinal
import Storage
import Tagged
import Testing

private typealias BoundedHeapColumn<E: ~Copyable> =
    Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Linear.Bounded

private typealias FixedArray<E: ~Copyable> = Fixed<E>

@Suite
struct `Fixed Column Law Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}

    @Test
    func `the bounded heap column obeys the seam ledger laws`() {
        let violations = Seam.Ledger.violations(
            makeEmpty: { BoundedHeapColumn<Int>(minimumCapacity: Index<Int>.Count(4)) },
            element: { $0 }
        )
        #expect(violations.isEmpty, "\(violations)")
    }
}

@Suite(.serialized)
struct `Fixed Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}

    @Test

    @_optimize(none)
    func `checked init populates every slot; properties hold`() throws {
        let f = try FixedArray<Int>(count: Index<Int>.Count(3)) { _ in 7 }
        let count = f.count
        #expect(count == Index<Int>.Count(3))
        let isEmpty = f.isEmpty
        #expect(!isEmpty)
        let free = f.freeCapacity
        #expect(free == Index<Int>.Count(0))
        let e1 = f.withElement(at: 1) { $0 }
        #expect(e1 == 7)
    }

    @Test

    @_optimize(none)
    func `repeating + subscript read-write + swap`() {
        var f = FixedArray<Int>(repeating: 1, count: Index<Int>.Count(3))
        f[0] = 10
        f[2] = 30
        f.swap(at: 0, with: 2)
        let e0 = f[0]
        let e2 = f[2]
        #expect(e0 == 30)
        #expect(e2 == 10)
        let opt = f.element(at: 1)
        #expect(opt == 1)
    }

    @Test

    @_optimize(none)
    func `mutableSpan writes through; index defaults navigate`() throws {
        var f = try FixedArray<Int>(count: Index<Int>.Count(2)) { _ in 5 }
        do {
            var m = f.mutableSpan()
            m[1] = 50
        }
        let e1 = f[1]
        #expect(e1 == 50)
        var walked: [Int] = []
        var i = f.startIndex
        while i < f.endIndex {
            walked.append(f[i])
            i = f.index(after: i)
        }
        #expect(walked == [5, 50])
    }

    @Test
    func `move-only elements live in Fixed and tear down once`() throws {
        Probe.reset()
        do {
            let f = try FixedArray<Item>(count: Index<Item>.Count(2)) { _ in Item(9) }
            f.withElement(at: 0) { item in
                #expect(item.id == 9)
            }
            _ = consume f
        }
        let count = Probe.destroyedCount
        #expect(count == 2)
    }
}

private enum Probe {}

extension Probe {

    nonisolated(unsafe) static var _destroyed: Int = 0
    static func reset() { unsafe _destroyed = 0 }
    static func record() { unsafe _destroyed += 1 }
    static var destroyedCount: Int { unsafe _destroyed }
}

private struct Item: ~Copyable {
    let id: Int
    init(_ id: Int) { self.id = id }
    deinit { Probe.record() }
}
