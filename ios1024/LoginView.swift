//
//  LoginView.swift
//  ios1024
//
//  Created by Shawn Chov on 11/30/24.
//

import SwiftUI

@available(iOS 16.0, *)
struct LoginView: View {
    // Navigation controls
    @EnvironmentObject var navi: Navigation
    // Accessing shared GameViewModel
    @EnvironmentObject var vm: GameViewModel
    @State var loginError: String = ""
    
    var body: some View {
        VStack {
            // Text on the login screen
            Text("Login Here")
            if loginError.count > 0 {
                Text("Login feedback \(loginError)")
            }
            HStack {
                Button("Sign In") {
                    navi.navigate(to: .LoginDestination)
                }
                Button("Sign Up") {
                    signUp()
                }
            }
        }.buttonStyle(.borderedProminent)
    }
    
    func signUp() {
        navi.navigate(to: .NewAccountDestination)
    }
    
}


#Preview {
    if #available(iOS 16.0, *) {
        LoginView()
    } else {
        // Fallback on earlier versions
    }
}
