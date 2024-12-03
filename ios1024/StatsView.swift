//
//  StatsView.swift
//  ios1024
//
//  Created by Shawn Chov on 11/12/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

/// View for displaying the game stats for the users
@available(iOS 16.0, *)
struct StatsView: View {
    // Navigator
    @EnvironmentObject var navi: Navigation
    @State private var gameStats: [GameStat] = [] // A list to hold game statistics

    var body: some View {
        VStack {
            // Title for game stats screen
            Text("Game Statistics")
                .font(.largeTitle)
                .padding()
            
            // A couple buttons for sorting
            HStack {
                Button("Sort by Moves") {
                    sortByMoves()
                }
                .buttonStyle(.bordered)
                .padding(.horizontal)

                Button("Sort by Date") {
                    sortByDate()
                }
                .buttonStyle(.bordered)
                .padding(.horizontal)
            }
            .padding(.bottom) // padding below the buttons to not look cluttered

            // List to display game statistics
            List(gameStats) { stat in
                VStack(alignment: .leading) {
                    Text("Game Date: \(stat.date, formatter: dateFormatter)")
                    Text("Board Size: \(stat.boardSize)")
                    Text("Goal Score: \(stat.goalScore)")
                    Text("Max Score: \(stat.maxScore)")
                    Text("Swipes: \(stat.swipeCount)")
                    Text("Win: \(stat.win ? "Yes" : "No")")
                        .foregroundColor(stat.win ? .green : .red) // Display win in green and loss in red
                }
                .padding(.vertical)
            }
            .onAppear {
                fetchGameStats() // When the view appears get the stats
            }

            Button("Back to Game") {
                navi.navBack()
            }
            .buttonStyle(.borderedProminent)
            .padding()

            Spacer()
        }
        .padding()
    }

    /// Fetch game stats for firestore
    func fetchGameStats() {
        // Load up the db for the current user
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()

        // Reference the user's games sub-collection
        let userGamesRef = db.collection("users").document(userId).collection("games")
        
        userGamesRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                // Error message if failure
                print("Error getting documents: \(error)")
            } else {
                // Map the documents to GameStat object
                gameStats = querySnapshot?.documents.compactMap { document -> GameStat? in
                    // Converts document into dict with the below key:value pairs
                    let data = document.data()
                    guard
                        let date = (data["dateAndTime"] as? Timestamp)?.dateValue(),
                        let boardSize = data["boardSize"] as? Int,
                        let goalScore = data["goalScore"] as? Int,
                        let maxScore = data["maxScore"] as? Int,
                        let swipeCount = data["moves"] as? Int,
                        let outcome = data["outcome"] as? String
                    else {
                        return nil // If any of the information is missing
                    }
                    // Return the game stats if pulling everything was successful
                    return GameStat(
                        id: document.documentID,
                        date: date,
                        boardSize: boardSize,
                        goalScore: goalScore,
                        maxScore: maxScore,
                        swipeCount: swipeCount,
                        win: outcome == "win"
                    )
                } ?? [] // GameStats is an empty array if data was not fetched properly
            }
        }
    }
    /// Sort by moves in ascending order (low to high)
    func sortByMoves() {
        gameStats.sort { $0.swipeCount < $1.swipeCount }
    }
    /// Sort by date descending (newest to oldest)
    func sortByDate() {
        gameStats.sort { $0.date > $1.date }
    }
}

// All the information for a game stat entry
struct GameStat: Identifiable {
    var id: String
    var date: Date
    var boardSize: Int
    var goalScore: Int
    var maxScore: Int
    var swipeCount: Int
    var win: Bool
}

// Helper function to format the date and time for game stats
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

#Preview {
    if #available(iOS 16.0, *) {
        StatsView()
    } else {
        // Fallback on earlier versions
    }
}
