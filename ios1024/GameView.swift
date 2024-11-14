//
//  ContentView.swift
//  ios1024
//
//  Created by Hans Dulimarta for CIS357
//

import SwiftUI


struct GameView: View {

    @State var swipeDirection: SwipeDirection? = Optional.none
    @StateObject var viewModel: GameViewModel = GameViewModel()
    var body: some View {
        VStack {
            Text("Welcome to 1024 by Shawn Chov!").font(.title2)
            NumberGrid(viewModel: viewModel)
                .gesture(DragGesture().onEnded {
                    swipeDirection = determineSwipeDirection($0)
                    viewModel.handleSwipe(swipeDirection!)
                })
                .padding()
                .frame(
                    maxWidth: .infinity
                )
            
            // Display win message
            if viewModel.playerWin {
                Text("You win!").font(.largeTitle).foregroundColor(.green)
            }
            
            // Display lose message
            if viewModel.gameOver {
                Text("You lost!").font(.largeTitle).foregroundStyle(.red)
            }
            
            // Added Reset Button and swipe counter information
            HStack {
                Button("Reset") {
                    viewModel.resetGame()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                // Puts space between the reset button and the swipe counter info
                Spacer()
                
                Text("Swipe Counter: \(viewModel.swipeCounter)")
            }
            .padding(.horizontal)
            
            
        }.padding(.all).frame(maxHeight: .infinity, alignment: .top)
    }
}

struct NumberGrid: View {
    @ObservedObject var viewModel: GameViewModel
    let size: Int = 4

    var body: some View {
        VStack(spacing: 4) {
            ForEach(0..<size, id: \.self) { row in
                HStack(spacing: 4) {
                    ForEach(0..<size, id: \.self) { column in
                        let cellValue = viewModel.grid[row][column]
                        let cellColor = viewModel.colorForNumber(cellValue) // Get the color for the current number
                        
                        Text(cellValue == 0 ? "" : "\(cellValue)") // Only display something if not zero
                            .font(.system(size: 26))
                            .foregroundColor(.black) // Text color
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                            .background(cellColor) // Set the background color based on the number
                            .cornerRadius(10)
                    }
                }
            }
        }
        .padding(4)
        .background(Color.gray.opacity(0.4))
    }
}


func determineSwipeDirection(_ swipe: DragGesture.Value) -> SwipeDirection {
    if abs(swipe.translation.width) > abs(swipe.translation.height) {
        return swipe.translation.width < 0 ? .left : .right
    } else {
        return swipe.translation.height < 0 ? .up : .down
    }
}


#Preview {
    GameView()
}
