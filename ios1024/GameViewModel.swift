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
        // Allow updates only if the player did not win and not game over
        guard !playerWin else { return }
        guard !gameOver else { return }
        
        // Get the previous grid state
        updatePreviousGrid()
        
        // Define vertical swipes and reverse swipes (logic is the same for up/down and left/right); just reversed
        let verticalSwipe = direction == .up || direction == .down
        let reverseSwipe = direction == .down || direction == .right
        
        // Loop over the grid and get the current line (either horizontal or vertical)
        for i in 0..<grid.count {
            var currentLine = [Int]()
            
            for j in 0..<grid.count {
                if verticalSwipe {
                    currentLine.append(grid[j][i])
                } else {
                    currentLine.append(grid[i][j])
                }
            }
        
            // Flip if needed
            if reverseSwipe {
                currentLine.reverse()
            }
            
            // Remove all the 0's and combine all the like numbers
            currentLine.removeAll() { $0 == 0 }
            combineAdjacent(&currentLine)
            
            // Append 0 (blanks) to ensure the row/col is back to the same size
            while currentLine.count < grid.count {
                currentLine.append(0)
            }
            
            // reverse it back if needed
            if reverseSwipe {
                currentLine.reverse()
            }
            
            // Put back the row/col where you got it from
            for j in 0..<grid.count {
                if verticalSwipe {
                    grid[j][i] = currentLine[j]
                } else {
                    grid[i][j] = currentLine[j]
                }
            }
        }
        // If something changed then insert the random new cell and increment the swipe count
        if flattenGrid() != previousGrid {
            insertRandom()
            incrementSwipeCount()
        }
        
        // Ensure the game has not been won/lost
        checkWinCondition()
        
        // If the game is over go to the end game tasks
        if isGameOver() {
            gameOver = true
            endGame()
        } else if playerWin == true {
            endGame()
        }
    }
    
    /// Sign in logic to see if you can log in with the username email and password
    func checkUserAcct(user: String, pwd: String) async -> Bool {
        do {
            try await Auth.auth().signIn(withEmail: user, password: pwd)
            return true
        } catch {
            print("Error \(error.localizedDescription)")
            return false
        }
    }
    
    
    /// Increments the swipe count for the user
    func incrementSwipeCount() {
        swipeCounter += 1
    }
    
    /// Resets the game to the starting state and resets the player state variables
    func resetGame() {
        // Will reinitialize the array and insert one random cell, reset needed vars
        let gridSize = grid.count
        grid = Array(repeating: Array(repeating: 0, count: gridSize), count: gridSize)
        playerWin = false
        gameOver = false
        swipeCounter = 0
        insertRandom()
    }
    
    /// Used for getting all information needed for the game statistics screen
    func endGame() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        // Reference to where I am saving the games in firebase
        let userGamesRef = db.collection("players").document(userId).collection("statistics")
        
        // Game data to be saved
        let gameData: [String: Any] = [
            "boardSize": grid.count,
            "goalScore": goalValue,
            "dateAndTime": Timestamp(),
            "maxScore": grid.flatMap { $0 }.max() ?? 0,
            "moves": swipeCounter,
            "outcome": playerWin ? "win" : "lose"
        ]
        // Add a new game document to the user's "games" sub-collection
        userGamesRef.addDocument(data: gameData) { error in
            if let error = error {
                print("Error saving game data: \(error)")
            } else {
                print("Game data saved successfully.")
            }
        }
    }
    
    /// Will put either a 2 or 4 on the game board in a random spot
    func insertRandom() {
        // Create a list of tuples
        var emptyCells = [(Int, Int)]()
        
        // Loop over the grid and append the empty grid coordinates to my emptyCells list
        for i in 0..<grid.count {
            for j in 0..<grid[i].count{
                if grid[i][j] == 0 {
                    emptyCells.append((i, j))
                }
            }
        }
        
        // If the list is not empty pick a random cell and put a 2 or 4 in it
        if !emptyCells.isEmpty {
            // Pick a random cell
            let randomCell = emptyCells.randomElement()!
            // Put a 2 or 4 in there
            let value = Int.random(in: 0..<10) < 8 ? 2 : 4
            // Put it in the grid
            grid[randomCell.0][randomCell.1] = value
            
        }
    }
    
    /// Will check to see if the user won the game or not
    func checkWinCondition() {
        // Loop over grid, if one contains the goal; player won
        for i in 0..<grid.count {
            for j in 0..<grid[i].count {
                if grid[i][j] == goalValue {
                    playerWin = true
                    return
                }
            }
        }
    }
    
    /// Will check to see if there is a valid move left or if the player lost
    func isGameOver() -> Bool {
        // Loop over grid; if there is a blank the game is not over
        for i in 0..<grid.count {
            for j in 0..<grid[i].count {
                if grid[i][j] == 0 {
                    return false
                }
            }
        }
        
        // Loop over grid; if there are 2 cells next to one another that are the same; game not over
        for i in 0..<grid.count {
            for j in 0..<grid[i].count {
                if j < grid[i].count - 1 && grid[i][j] == grid[i][j+1] {
                    return false
                }
                if i < grid.count - 1 && grid[i][j] == grid[i+1][j] {
                    return false
                }
            }
        }
        return true
    }
}