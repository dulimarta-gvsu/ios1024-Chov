//
//  ContentView.swift
//  ios1024
//
//  Created by Hans Dulimarta for CIS357
//

import SwiftUI

struct GameView: View {
    @State var swipeDirection: SwipeDirection? = .none
    @StateObject var viewModel: GameViewModel = GameViewModel()

    var body: some View {
        VStack {
            // Header with your name
            Text("Welcome to 1024 by Shawn Chov!").font(.title2)

            // Display number of valid swipes and game status
            HStack {
                Text("Valid Swipes: \(viewModel.validSwipes)")
                Spacer()
                Text(viewModel.gameStatus).font(.headline)
            }
            .padding()

            // Number grid for displaying the board
            NumberGrid(viewModel: viewModel)
                .gesture(DragGesture().onEnded {
                    swipeDirection = determineSwipeDirection($0)
                    viewModel.handleSwipe(swipeDirection ?? .none)
                })
                .padding()
                .frame(
                    maxWidth: .infinity
                )

            if let swipeDirection {
                Text("You swiped \(swipeDirection)")
            }

            // RESET Button
            Button(action: {
                viewModel.resetGame()
            }) {
                Text("Reset Game")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top)
        }
        .frame(maxHeight: .infinity, alignment: .top)
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
                        Text("\(cellValue != 0 ? "\(cellValue)" : "")")
                            .font(.system(size: 26))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                            .background(cellValue == 0 ? Color.gray.opacity(0.2) : Color.white)
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
