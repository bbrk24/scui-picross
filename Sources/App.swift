import SwiftCrossUI
import DefaultBackend

func getLabels(for row: [Bool]) -> [Int] {
    var currentStreak = 0
    var result: [Int] = []

    for b in row {
        if b {
            currentStreak += 1
        } else if currentStreak > 0 {
            result.append(currentStreak)
            currentStreak = 0
        }
    }
    if currentStreak > 0 {
        result.append(currentStreak)
    }

    return result
}

@main
public struct PicrossApp: App {
    static let padding = 10
    static let fontSize = 16

    let solution: [[Bool]]
    let columnLabels: [[Int]]
    let rowLabels: [[Int]]
    @State var grid: [[CellState]]
    @State var hasWon = false
    @State var showAlert = false

    private let majorGridSize = 5
    private let windowWidth: Int
    private let windowHeight: Int

    public init() {
        let rows = solutionStr.components(separatedBy: .newlines)
        let columnCount = rows.map(\.count).max()!

        solution = rows.map {
            let start = $0.map { $0 != " " }
            let rest = Array(repeating: false, count: columnCount - start.count)
            return start + rest
        }

        rowLabels = solution.map(getLabels(for:))
        columnLabels = solution.transpose().map(getLabels(for:))

        grid = Array(repeating: Array(repeating: .blank, count: columnCount), count: rows.count)

        let verticalHintCount = columnLabels.map(\.count).max()!
        let horizontalHintCount = rowLabels.map(\.count).max()!
        let lineHeight = Int(Double(PicrossApp.fontSize) * 1.625)

        windowWidth =
            columnCount * Grid.gridSize
            + (columnCount + 2 + columnCount / majorGridSize) * Grid.rowSpacing
            + horizontalHintCount * lineHeight
            + (horizontalHintCount + 1) * 2 * Grid.labelPadding
            + 2 * PicrossApp.padding
        windowHeight =
            rows.count * Grid.gridSize
            + (rows.count + 2 + rows.count / majorGridSize) * Grid.rowSpacing
            + (verticalHintCount + 3) * lineHeight
            + (verticalHintCount + 1) * 2 * Grid.labelPadding
            + 4 * PicrossApp.padding
    }
    
    public var body: some Scene {
        WindowGroup("Picross") {
            VStack(spacing: 0) {
                Grid(
                    contents: $grid,
                    columnLabels: columnLabels,
                    rowLabels: rowLabels,
                    majorGridSize: majorGridSize
                )
                    .padding(PicrossApp.padding)

                Text("Left-click to fill in a cell; right-click to mark a cell as blank.")
                    .multilineTextAlignment(.center)
                    .padding(PicrossApp.padding)
            }
            .font(.system(size: PicrossApp.fontSize))
            .onChange(of: grid, initial: false) {
                if !hasWon && grid.map({ $0.map { $0 == .filled } }) == solution {
                    hasWon = true
                    showAlert = true
                }
            }
            .alert("You Win!", isPresented: $showAlert) {
                Button("OK") {
                    showAlert = false
                }
            }
        }
        .defaultSize(width: windowWidth, height: windowHeight)
    }
}

let solutionStr = """
XXXXX
   X
   X
X  X
 XX
"""
