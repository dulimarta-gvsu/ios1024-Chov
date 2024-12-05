//
//  Navigation.swift
//  ios1024
//
//  Created by Shawn Chov on 11/12/24.
//

import SwiftUI

/// Enum for all my screens
enum Destination {
    case LoginDestination
    case NewAccountDestination
    case GameDestination
    case SettingsDestination
    case StatisticDestination
}

@available(iOS 16.0, *)
class Navigation: ObservableObject {
    // Holds the navigation path for the NavigationStack
    @Published var navPath: NavigationPath = NavigationPath()
    
    /// Adding to this array will change the screen
    func navigate(to d: Destination) {
        navPath.append(d)
    }
    
    /// For my back buttons
    func navBack() {
        navPath.removeLast()
    }
    
    /// Will take you back to start (login)
    func backHome() {
        while navPath.count > 0 {
            navPath.removeLast()
        }
    }
}
