enum CellState {
    case blank, filled, crossedOut

    mutating func toggleFilled() {
        switch self {
        case .blank:
            self = .filled
        case .filled:
            self = .blank
        case .crossedOut:
            break
        }
    }

    mutating func toggleCrossedOut() {
        switch self {
        case .blank:
            self = .crossedOut
        case .filled:
            break
        case .crossedOut:
            self = .blank
        }
    }
}
