//
//  SettingsView.swift
//  ios1024
//
//  Created by Shawn Chov on 11/12/24.
//

import SwiftUI

@available(iOS 16.0, *)
struct SettingsView: View {
    // Navigator
    @EnvironmentObject var navi: Navigation
    // Access to shared GameViewModel
    @EnvironmentObject var viewModel: GameViewModel
    // These can change but are defaulted to 4x4 grid and 1024 goal
    @State private var selectedGridSize: Int = 4
    @State private var selectedGoalValue: Int = 1024
    
    var body: some View {
        VStack {
            // Text at the top of the screen
            Text("Preferences")
                .font(.largeTitle)
                .padding()
            
            // Displays the Grid Size option 3x3 - 7x7
            VStack(alignment: .leading) {
                Text("Grid Size")
                    .font(.headline)
                Picker("Grid Size", selection: $selectedGridSize) {
                    ForEach([3, 4, 5, 6, 7], id: \.self) { size in
                        Text("\(size) x \(size)").tag(size)
                    }
                }
                .pickerStyle(SegmentedPickerStyle()) // Pretty selection option
            }
            .padding()
            
            VStack(alignment: .leading) {
                // Displays the Goal Number option
                Text("Goal Number")
                    .font(.headline)
                Picker("Goal Number", selection: $selectedGoalValue) {
                    ForEach([128, 256, 512, 1024, 2048, 4096], id: \.self) { goal in
                        Text("\(goal)").tag(goal)
                    }
                }
                .pickerStyle(SegmentedPickerStyle()) // Pretty selection option
            }
            .padding()
            
            // Buttons for saving changes or going back to game
            HStack {
                Button("Save Pref") {
                    savePref()
                }
                Button("Cancel") {
                    navi.navBack()
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .padding()
        .onAppear {
            // Update the selected values to show what the current settings are
            selectedGridSize = viewModel.grid.count
            selectedGoalValue = viewModel.goalValue
        }
    }
    
    /// Save the selected options
    func savePref() {
        // Update the grid size (only if it has been changed)
        if selectedGridSize != viewModel.grid.count {
            viewModel.updateGridSize(gridSize: selectedGridSize)
        }
        
        // Update the goal values (only if it has been changed)
        if selectedGoalValue != viewModel.goalValue {
            viewModel.updateGoalValue(goal: selectedGoalValue)
        }
        navi.navBack()
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        SettingsView()
    } else {
        // Fallback on earlier versions
    }
}
