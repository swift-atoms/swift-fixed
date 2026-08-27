public import Index
public import Store_Protocol

extension __Fixed where S: Store.`Protocol` & ~Copyable {

    public enum Error: Swift.Error, Sendable, Equatable {

        case invalidCount(Index.Index<S.Element>.Count)

        case indexOutOfBounds(
            index: Index.Index<S.Element>,
            count: Index.Index<S.Element>.Count
        )
    }
}
