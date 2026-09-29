import Fixed
import Cardinal
import Ordinal
import Storage
import Tagged
import Testing

private typealias FixedArray<E: ~Copyable> = Fixed::Fixed<E>

@Suite(.serialized)
struct `Fixed Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}

    @Test

    @_optimize(none)
    func `checked init populates every slot; properties hold`() throws {
        let f = try FixedArray<Int>(count: Tagged<Int, Cardinal>(3)) { _ in 7 }
        let count = f.count
        #expect(count == Tagged<Int, Cardinal>(3))
        let isEmpty = f.isEmpty
        #expect(!isEmpty)
        let free = f.freeCapacity
        #expect(free == Tagged<Int, Cardinal>(0))
        let e1 = f.withElement(at: 1) { $0 }
        #expect(e1 == 7)
    }

    @Test

    @_optimize(none)
    func `repeating + subscript read-write + swap`() {
        var f = FixedArray<Int>(repeating: 1, count: Tagged<Int, Cardinal>(3))
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
    func `index defaults navigate`() throws {
        var f = try FixedArray<Int>(count: Tagged<Int, Cardinal>(2)) { _ in 5 }
        f[1] = 50
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
            let f = try FixedArray<Item>(count: Tagged<Item, Cardinal>(2)) { _ in Item(9) }
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
