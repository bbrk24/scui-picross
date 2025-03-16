struct EnumeratedZip<T: Sequence, U: Sequence> {
    private var first: T
    private var second: U

    init(_ first: T, _ second: U) {
        self.first = first
        self.second = second
    }
}

extension EnumeratedZip: Sequence {
    typealias Element = (T.Element, U.Element, Int)

    var underestimatedCount: Int { Swift.min(first.underestimatedCount, second.underestimatedCount) }

    func makeIterator() -> some IteratorProtocol<Element> {
        zip(first, second).enumerated().lazy.map { ($1.0, $1.1, $0) }.makeIterator()
    }
}

extension EnumeratedZip: Collection
where T: Collection, U: Collection {
    typealias Index = Int
    typealias Indices = Range<Int>

    var startIndex: Int { 0 }
    var endIndex: Int { Swift.min(first.count, second.count) }
    var indices: Range<Int> { startIndex..<endIndex }
    var isEmpty: Bool { first.isEmpty || second.isEmpty }
    var count: Int { endIndex }

    subscript(position: Int) -> (T.Element, U.Element, Int) {
        let tIndex = first.index(first.startIndex, offsetBy: position)
        let uIndex = second.index(second.startIndex, offsetBy: position)
        return (first[tIndex], second[uIndex], position)
    }

    func index(after i: Int) -> Int {
        assert(i < endIndex)
        return i &+ 1
    }

    func index(_ i: Int, offsetBy distance: Int) -> Int {
        let result = i + distance
        assert(result <= endIndex)
        return result
    }

    func distance(from start: Int, to end: Int) -> Int {
        assert(0 <= start && start <= end && end <= endIndex)
        return end &- start
    }

    func formIndex(after i: inout Int) {
        assert(i < endIndex)
        i &+= 1
    }
}
