public import Index
public import Storage

extension __Fixed where S: Store.Ledgered.`Protocol` & ~Copyable {

    public enum Error: Swift.Error, Sendable, Equatable {

        case invalidCount(Index<S.Element>.Count)

        case indexOutOfBounds(
            index: Index<S.Element>,
            count: Index<S.Element>.Count
        )

        @inlinable
        public static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.invalidCount(let lhs), .invalidCount(let rhs)):
                lhs.rawValue == rhs.rawValue
            case (
                .indexOutOfBounds(let lhsIndex, let lhsCount),
                .indexOutOfBounds(let rhsIndex, let rhsCount)
            ):
                lhsIndex.rawValue == rhsIndex.rawValue
                    && lhsCount.rawValue == rhsCount.rawValue
            default:
                false
            }
        }
    }
}
