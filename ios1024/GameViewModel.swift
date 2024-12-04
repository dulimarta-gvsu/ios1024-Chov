
//
//  GameViewMode.swift
//  ios1024
//
//  Created by Hans Dulimarta for CIS357
//
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

// Main view for game logic
class GameViewModel: ObservableObject {
    @Published var grid: Array<Array<Int>>
    private var previousGrid: [Int] = []
    @Published var goalValue: Int
    var playerWin: Bool = false
    var gameOver: Bool = false
    var swipeCounter: Int = 0
    
    // Initialize the grid to 4x4 and the goal to 1024
    init (gridSize: Int = 4, goalValue: Int = 1024) {
        self.goalValue = goalValue
        self.grid = Array(repeating: Array(repeating: 0, count: gridSize), count: gridSize)
        insertRandom()
    }
    
    /// To change the grid size
    func updateGridSize(gridSize: Int) {
        self.grid = Array(repeating: Array(repeating: 0, count: gridSize), count: gridSize)
        resetGame()
    }
    /// To change the goal value
    func updateGoalValue(goal: Int) {
        self.goalValue = goal
    }
    
 func colorForNumber(_ number: Int) -> Color {
            switch number {
            case 0:
                return Color.gray.opacity(0.3) // Empty cell (0)
            case 2:
                return Color(red: 238/255, green: 228/255, blue: 218/255) // Light gray (2)
            case 4:
                return Color(red: 237/255, green: 224/255, blue: 200/255) // Light yellow (4)
            case 8:
                return Color(red: 255/255, green: 176/255, blue: 101/255) // Light orange (8)
            case 16:
                return Color(red: 255/255, green: 127/255, blue: 39/255) // Red (16)
            case 32:
                return Color(red: 255/255, green: 103/255, blue: 63/255) // Dark red (32)
            case 64:
                return Color(red: 255/255, green: 93/255, blue: 35/255) // Dark orange (64)
            case 128:
                return Color(red: 242/255, green: 85/255, blue: 36/255) // Light red (128)
            case 256:
                return Color(red: 237/255, green: 204/255, blue: 97/255) // Greenish-yellow (256)
            case 512:
                return Color(red: 237/255, green: 204/255, blue: 58/255) // Blue (512)
            case 1024:
                return Color(red: 237/255, green: 179/255, blue: 39/255) // Purple (1024)
            case 2048:
                return Color(red: 253/255, green: 220/255, blue: 62/255) // Gold (2048)
            default:
                return Color.black // Default for unknown values (shouldn't happen)
            }
        }

    /// Will put the 2-d array into 1-d array
    func flattenGrid() -> [Int] {
        grid.flatMap { $0 }
    }
    
    /// Get the state of the grid in a 1-d array
    func updatePreviousGrid() {
        previousGrid = flattenGrid()
    }
    
    /// Combines adjacent numbers on swipe
    func combineAdjacent(_ currentLine: inout [Int]) {
        var i = 0
        
        // While you are not at the end of the line
        while i < currentLine.count - 1 {
            // if it is a 0 (blank space) increment i
            if currentLine[i] == 0 {
                i+=1
                continue
            }
            
            // if the space we are looking at is identical to the next; combine
            if currentLine[i] == currentLine[i+1] {
                currentLine[i] = currentLine[i] * 2
                currentLine.remove(at: i + 1)
                currentLine.append(0)
            }
            i+=1
        }
    }
    
    /// Main game logic
    func handleSwipe(_ direction: SwipeDirection) {
        let fillValue = switch(direction) {
        case .left:  1
        case .right:  2
        case .up:  3
        case .down:  4
        }
        
        for r in 0 ..< grid.count {
            for c in 0 ..< grid[r].count {
                grid[r][c] = fillValue
            }
        }
    }
}
