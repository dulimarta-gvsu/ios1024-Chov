//
//  AppView.swift
//  ios1024
//
//  Created by Shawn Chov on 11/12/24.
//

import SwiftUI

/// Main entry point for the app
@available(iOS 16.0, *)
struct AppView: View {
    // Updates UI when data changes, any change in navPath property in navCtrl will trigger AppView to update
    @ObservedObject private var navCtrl: Navigation = Navigation()
    // GameViewModel will stay alive as long as long as the view is alive
    @StateObject var vm: GameViewModel = GameViewModel()
    
    var body: some View {
        // Navigates the screen stack
        NavigationStack(path: $navCtrl.navPath) {
            LoginView()
                .environmentObject(vm)
                .environmentObject(navCtrl)
                // Handles the possible destinations, based on the Destination Enum
                .navigationDestination(for: Destination.self) { dest in
                    switch(dest) {
                    case .GameDestination: GameView().navigationBarBackButtonHidden(true).environmentObject(vm)
                    case .NewAccountDestination: NewAccountView().environmentObject(vm)
                    case .SettingsDestination: SettingsView().environmentObject(vm)
                    case .StatisticDestination: StatsView().environmentObject(vm)
                    case .LoginDestination: SignInView().environmentObject(vm)
                    }
                }
        }
        .environmentObject(navCtrl) // Makes all views able to use the navCtrl
    }
}
