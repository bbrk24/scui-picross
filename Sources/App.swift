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
    let solution: [[Bool]]
    let columnLabels: [[Int]]
    let rowLabels: [[Int]]
    @State var grid: [[CellState]]
    @State var hasWon = false
    @State var showAlert = false

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
    }
    
    public var body: some Scene {
        WindowGroup("Picross") {
            VStack {
                Grid(contents: $grid, columnLabels: columnLabels, rowLabels: rowLabels)
                    .padding()

                Text("Left-click to fill in a cell; right-click to mark a cell as blank.")
                    .multilineTextAlignment(.center)
                    .padding()
            }
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
    }
}

let solutionStr = """
XXXXX
   X
   X
X  X
 XX
"""
