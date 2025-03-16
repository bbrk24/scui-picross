// https://stackoverflow.com/a/39891965/6253337
extension Collection
where Element: RandomAccessCollection {
    func transpose() -> [[Element.Element]] {
        guard let firstRow = self.first else { return [] }
        return firstRow.indices.map { index in
            self.map{ $0[index] }
        }
    }
}
