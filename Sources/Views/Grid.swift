import SwiftCrossUI

struct Grid: View {
    static let gridSize = 24
    static let labelPadding = 3
    static let rowSpacing = 2

    @Binding var contents: [[CellState]]
    var columnLabels: [[Int]]
    var rowLabels: [[Int]]
    var majorGridSize = 5

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: Grid.rowSpacing) {
            HStack(spacing: Grid.rowSpacing) {
                Spacer()

                ForEach(Array(columnLabels.enumerated())) { columnIndex, labelSet in
                    VStack(spacing: 0) {
                        Spacer(minLength: 0)

                        ForEach(labelSet) { number in
                            Text("\(number)")
                                .padding([.vertical], Grid.labelPadding)
                        }
                    }
                    .frame(width: Grid.gridSize)
                    .background(colorScheme == .dark ? Color.black : Color.white)
                    .padding([.leading], columnIndex % majorGridSize == 0 ? Grid.rowSpacing : 0)
                }
            }

            ForEach(EnumeratedZip(rowLabels, contents)) { labelSet, row, rowIndex in
                HStack(spacing: Grid.rowSpacing) {
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
                        .padding([.leading], columnIndex % majorGridSize == 0 ? Grid.rowSpacing : 0)
                    }
                }
                .padding([.top], rowIndex % majorGridSize == 0 ? Grid.rowSpacing : 0)
            }
        }
        .padding([.bottom, .trailing], Grid.rowSpacing)
        .background(Color.gray)
    }
}

