//
//  ContentView.swift
//  ios1024
//
//  Created by Hans Dulimarta for CIS357
//

import SwiftUI

<<<<<<< Updated upstream
struct GameView: View {
    @State var swipeDirection: SwipeDirection? = .none
    @StateObject var viewModel: GameViewModel = GameViewModel()
    var body: some View {
        VStack {
            Text("Welcome to 1024 by YourName!").font(.title2)
=======
@available(iOS 16.0, *)
struct GameView: View {
    // Tracks swipe dir
    @State var swipeDirection: SwipeDirection? = .none
    // Tracks the shared GameViewModel
    @EnvironmentObject var viewModel: GameViewModel
    // Handles navigator
    @EnvironmentObject var navi: Navigation
    
    var body: some View {
        VStack {
            Text("Welcome to 1024 by Shawn Chov").font(.title2)
            
            // Displays the grid and adds swipe gesture
>>>>>>> Stashed changes
            NumberGrid(viewModel: viewModel)
                .gesture(DragGesture().onEnded {
                    swipeDirection = determineSwipeDirection($0)
                    viewModel.handleSwipe(swipeDirection!)
                })
                .padding()
                .frame(
<<<<<<< Updated upstream
                    maxWidth: .infinity
                )
            if let swipeDirection {
                Text("You swiped \(swipeDirection)")
            }
        }.frame(maxHeight: .infinity, alignment: .top)
    }
}

struct NumberGrid: View {
    @ObservedObject var viewModel: GameViewModel
    let size: Int = 4

    var body: some View {
        VStack(spacing:4) {
            ForEach(0..<size, id: \.self) { row in
                HStack (spacing:4) {
                    ForEach(0..<size, id: \.self) { column in
                        let cellValue = viewModel.grid[row][column]
                        Text("\(cellValue)")
                            .font(.system(size:26))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                            .background(Color.white)
                            .cornerRadius(10)
=======
                    maxWidth: .infinity // Grid fills entire width of screen
                )
            
            // All buttons
            HStack {
                Button("Logout") {
                    navi.backHome()
                }
                Button("Settings") {
                    navi.navigate(to: .SettingsDestination)
                }
                Button("Stats") {
                    navi.navigate(to: .StatisticDestination)
                }
            }.buttonStyle(.borderedProminent)
            
            // Display win message
            if viewModel.playerWin {
                Text("You win!").font(.largeTitle).foregroundColor(.green)
            }
            
            // Display lose message
            if viewModel.gameOver {
                Text("You lose!").font(.largeTitle).foregroundStyle(.red)
            }
            
            // Added Reset Button and swipe counter information
            HStack {
                Button("Reset") {
                    viewModel.resetGame()
                }
                .padding()
                .background(Color.blue) // Makes the button blue
                .foregroundColor(.white) // Text white
                .cornerRadius(10) // Pretty rounded corners
                
                // Puts space between the reset button and the swipe counter info
                Spacer()
                
                Text("Swipe Counter: \(viewModel.swipeCounter)")
            }
            .padding(.horizontal)
            
        }.padding(.all).frame(maxHeight: .infinity, alignment: .top) // align vstack to top
    }
}

// The main game grid
struct NumberGrid: View {
    // Observes the changes from GameViewModel to update the UI
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        let size = viewModel.grid.count // Get grid size from GVM
        VStack(spacing:4) {
            // Loop through the rows in the grid
            ForEach(0..<size, id: \.self) { row in
                HStack (spacing:4) {
                    // Loop through the cols in the grid
                    ForEach(0..<size, id: \.self) { column in
                        let cellValue = viewModel.grid[row][column]
                        // Display the value in the cell if it isn't 0
                        Text(cellValue == 0 ? "" : "\(cellValue)")
                            .font(.system(size:26))
                            .foregroundColor(.black) // Black Text
                            .frame(maxWidth: .infinity, maxHeight: .infinity) // Cell fills entire space
                            .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit) // 1:1 aspect ratio
                            .background(Color.white) // Background white
                            .cornerRadius(10) // Round corners
>>>>>>> Stashed changes
                    }
                }
            }
        }
        .padding(4)
<<<<<<< Updated upstream
        .background(Color.gray.opacity(0.4))
    }
}

=======
        .background(Color.gray.opacity(0.4)) // Covers the grid, but can still see the numbers
    }
}

/// Determines the dir of swipe
>>>>>>> Stashed changes
func determineSwipeDirection(_ swipe: DragGesture.Value) -> SwipeDirection {
    if abs(swipe.translation.width) > abs(swipe.translation.height) {
        return swipe.translation.width < 0 ? .left : .right
    } else {
        return swipe.translation.height < 0 ? .up : .down
    }
}


#Preview {
<<<<<<< Updated upstream
    GameView()
=======
    if #available(iOS 16.0, *) {
        GameView()
    } else {
        // Fallback on earlier versions
    }
>>>>>>> Stashed changes
}
