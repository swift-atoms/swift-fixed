import Fixed
import Cardinal
import Ordinal
import Tagged
import Testing

private typealias Array3<E: ~Copyable> = Fixed::Fixed<E>

@Suite(.serialized)
struct `Fixed boundaries` {
    @Test
    func `element access stops at the count`() {
        var f = Array3<Int>(repeating: 0, count: Tagged<Int, Cardinal>(3))
        f[0] = 10
        f[1] = 11
        f[2] = 12
        let v1 = f.element(at: 2)
        #expect(v1 == 12)
        let v2 = f.element(at: 3)
        #expect(v2 == nil)
    }

    @Test
    func `offset access returns nil past either end`() {
        var f = Array3<Int>(repeating: 0, count: Tagged<Int, Cardinal>(3))
        f[2] = 7
        let v3 = f.element(at: 0, offsetBy: 2)
        #expect(v3 == 7)
        let v4 = f.element(at: 0, offsetBy: 3)
        #expect(v4 == nil)
        let v5 = f.element(at: 1, offsetBy: -2)
        #expect(v5 == nil)
    }

    @Test
    func `an empty buffer has no elements`() {
        let f = Array3<Int>(repeating: 0, count: Tagged<Int, Cardinal>(0))
        let v6 = f.isEmpty
        #expect(v6)
        let v7 = f.element(at: 0)
        #expect(v7 == nil)
        let v8 = f.startIndex
        let end = f.endIndex
        #expect(v8 == end)
    }

    @Test
    func `swapping an index with itself changes nothing`() {
        var f = Array3<Int>(repeating: 5, count: Tagged<Int, Cardinal>(2))
        f[1] = 6
        f.swap(at: 1, with: 1)
        let v9 = f.element(at: 0)
        #expect(v9 == 5)
        let v10 = f.element(at: 1)
        #expect(v10 == 6)
    }
}
