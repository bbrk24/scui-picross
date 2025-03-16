import SwiftCrossUI

struct Grid: View {
    static let gridSize = 24
    static let fontSize = 16
    static let labelPadding = 3

    @Binding var contents: [[CellState]]
    var columnLabels: [[Int]]
    var rowLabels: [[Int]]

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 2) {
            HStack(spacing: 2) {
                Spacer()

                ForEach(columnLabels) { labelSet in
                    VStack(spacing: 0) {
                        ForEach(labelSet) { number in
                            Text("\(number)")
                                .padding([.vertical], Grid.labelPadding)
                        }

                        Spacer(minLength: 0)
                    }
                    .frame(width: Grid.gridSize)
                    .background(colorScheme == .dark ? Color.black : Color.white)
                }
            }

            ForEach(EnumeratedZip(rowLabels, contents)) { labelSet, row, rowIndex in
                HStack(spacing: 2) {
                    HStack(spacing: 0) {
                        Spacer(minLength: 0)

                        ForEach(labelSet) { number in
                            Text("\(number)")
                                .padding([.horizontal], Grid.labelPadding)
                        }
                    }
                    .frame(height: Grid.gridSize)
                    .background(colorScheme == .dark ? Color.black : Color.white)

                    ForEach(Array(row.enumerated())) { columnIndex, cell in
                        Group {
                            switch (cell, colorScheme) {
                            case (.blank, .light), (.filled, .dark):
                                Color.white
                                    .frame(width: Grid.gridSize, height: Grid.gridSize)
                            case (.filled, .light), (.blank, .dark):
                                Color.black
                                    .frame(width: Grid.gridSize, height: Grid.gridSize)
                            case (.crossedOut, .light):
                                Text("X")
                                    .frame(width: Grid.gridSize, height: Grid.gridSize)
                                    .background(Color.white)
                            case (.crossedOut, .dark):
                                Text("X")
                                    .frame(width: Grid.gridSize, height: Grid.gridSize)
                                    .background(Color.black)
                            }
                        }
                        .onTapGesture(gesture: .primary) {
                            contents[rowIndex][columnIndex].toggleFilled()
                        }
                        .onTapGesture(gesture: .secondary) {
                            contents[rowIndex][columnIndex].toggleCrossedOut()
                        }
                    }
                }
            }
        }
        .background(Color.gray)
        .font(.system(size: Grid.fontSize))
    }
}

