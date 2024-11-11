import SwiftUI

enum SwipeDirection {
    case up, down, left, right, none
}

class GameViewModel: ObservableObject {
    @Published var grid: [[Int]]
    @Published var validSwipes: Int = 0
    @Published var gameStatus: String = "In Progress"
    
    let size: Int = 4

    // Initialize game state
    init() {
        self.grid = createEmptyGrid()
        placeRandomNumber()
    }

    // Create an empty grid
    func createEmptyGrid() -> [[Int]] {
        return Array(repeating: Array(repeating: 0, count: size), count: size)
    }

    // Reset the game
    func resetGame() {
        grid = createEmptyGrid()
        placeRandomNumber()
        validSwipes = 0
        gameStatus = "In Progress"
    }

    // Insert a random number (2 or 4) into an empty spot
    func placeRandomNumber() {
        var emptyCells: [(Int, Int)] = []
        for row in 0..<size {
            for col in 0..<size {
                if grid[row][col] == 0 {
                    emptyCells.append((row, col))
                }
            }
        }
        
        if let randomCell = emptyCells.randomElement() {
            grid[randomCell.0][randomCell.1] = (Bool.random() ? 2 : 4)
        }
    }

    // Handle swipe action (up, down, left, right)
    func handleSwipe(_ direction: SwipeDirection) {
        let previousGrid = grid // Store previous grid for change detection
        switch direction {
        case .up:
            swipeUp()
        case .down:
            swipeDown()
        case .left:
            swipeLeft()
        case .right:
            swipeRight()
        case .none:
            break
        }

        // Only insert a new number if the board has changed
        if grid != previousGrid {
            placeRandomNumber()
            validSwipes += 1
        }

        checkForWin()
        checkForGameOver()
    }

    // Swipe actions (up, down, left, right)
    func swipeUp() {
        for col in 0..<size {
            var column = grid.map { $0[col] } // Extract column
            column = swipeColumn(column)
            for row in 0..<size {
                grid[row][col] = column[row]
            }
        }
    }

    func swipeDown() {
        for col in 0..<size {
            var column = grid.map { $0[col] }
            column = swipeColumn(column.reversed()).reversed()
            for row in 0..<size {
                grid[row][col] = column[row]
            }
        }
    }

    func swipeLeft() {
        for row in 0..<size {
            grid[row] = swipeColumn(grid[row])
        }
    }

    func swipeRight() {
        for row in 0..<size {
            grid[row] = swipeColumn(grid[row].reversed()).reversed()
        }
    }

    // Swipe logic for a single row or column (merging cells)
    func swipeColumn(_ values: [Int]) -> [Int] {
        var newValues = values.filter { $0 != 0 } // Remove zeros
        var result = [Int](repeating: 0, count: size)
        
        var i = 0
        while i < newValues.count {
            if i + 1 < newValues.count && newValues[i] == newValues[i + 1] {
                result[i] = newValues[i] * 2
                i += 2 // Skip the next number as it was merged
            } else {
                result[i] = newValues[i]
                i += 1
            }
        }
        return result
    }

    // Detect if the game is won
    func checkForWin() {
        for row in grid {
            if row.contains(2048) {
                gameStatus = "WIN"
                return
            }
        }
    }

    // Detect game over condition
    func checkForGameOver() {
        if gridIsFull() && !canMerge() {
            gameStatus = "LOSE"
        }
    }

    // Check if the grid is full
    func gridIsFull() -> Bool {
        for row in grid {
            if row.contains(0) {
                return false
            }
        }
        return true
    }

    // Check if there are any possible merges left
    func canMerge() -> Bool {
        // Check for possible merges in rows and columns
        for row in grid {
            for i in 0..<size - 1 {
                if row[i] == row[i + 1] {
                    return true
                }
            }
        }
        
        for col in 0..<size {
            for row in 0..<size - 1 {
                if grid[row][col] == grid[row + 1][col] {
                    return true
                }
            }
        }
        
        return false
    }
}
