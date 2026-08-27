import Fixed
import Index
import Storage
import Testing

@Suite
struct `Fixed Tests` {
    @Suite struct Unit {

        @Test
        func `full inline store establishes the fixed invariant`() {
            let fixed = Fixed(store: makeStore())
            let count = fixed.count
            let capacity = fixed.capacity
            let freeCapacity = fixed.freeCapacity
            let isEmpty = fixed.isEmpty
            let first = fixed.startIndex
            let firstValue = fixed[first]

            #expect(count == capacity)
            #expect(freeCapacity == .zero)
            #expect(!isEmpty)
            #expect(firstValue == 1)
        }

        @Test
        func `subscript replacement preserves fullness`() {
            var fixed = Fixed(store: makeStore())
            let second = fixed.index(after: fixed.startIndex)

            fixed[second] = 20
            let value = fixed[second]
            let count = fixed.count
            let capacity = fixed.capacity
            let freeCapacity = fixed.freeCapacity

            #expect(value == 20)
            #expect(count == capacity)
            #expect(freeCapacity == .zero)
        }

        @Test
        func `swap exchanges elements without opening a slot`() {
            var fixed = Fixed(store: makeStore())
            let first = fixed.startIndex
            let third = fixed.index(before: fixed.endIndex)

            fixed.swap(at: first, with: third)
            let firstValue = fixed[first]
            let thirdValue = fixed[third]
            let count = fixed.count
            let capacity = fixed.capacity

            #expect(firstValue == 3)
            #expect(thirdValue == 1)
            #expect(count == capacity)
        }
    }

    @Suite struct `Edge Case` {

        @Test
        func `zero-capacity inline store is a valid empty fixed store`() {
            let fixed = Fixed(store: Store.Inline<Int, 0>())
            let isEmpty = fixed.isEmpty
            let count = fixed.count
            let capacity = fixed.capacity

            #expect(isEmpty)
            #expect(count == .zero)
            #expect(count == capacity)
        }
    }
    @Suite struct Integration {}
}

private func makeStore() -> Store.Inline<Int, 3> {
    var store = Store.Inline<Int, 3>()
    for rawValue in UInt(0)..<UInt(3) {
        let index = Index<Int>(rawValue)
        store.initialize(at: index, to: Int(rawValue + 1))
    }
    return store
}
