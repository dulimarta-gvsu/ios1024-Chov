//
//  NewAccountView.swift
//  ios1024
//
//  Created by Shawn Chov on 11/12/24.
//

import SwiftUI
import FirebaseAuth

/// View for creating a user account
@available(iOS 16.0, *)
struct NewAccountView: View {
    // Navigation control
    @EnvironmentObject var navi: Navigation
    // Email, pass, and error
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var createError: String = ""

    var body: some View {
        VStack {
            Text("Create a New Account")
                .font(.largeTitle)
                .padding()

            // Email TextField
            TextField("Email", text: $email)
                .padding()
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never) // Dont capitalize words
                .disableAutocorrection(true) // No autocorrect
                .background(Color.gray.opacity(0.2)) // Make the background look pretty
                .cornerRadius(8) // Round the corners
                .padding(.horizontal)

            // Password SecureField
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal)

            // Create Account Button
            Button("Create Account") {
                createAccount()
            }
            .buttonStyle(.borderedProminent)
            .padding()

            // Error Message
            if !createError.isEmpty {
                Text(createError)
                    .foregroundColor(.red)
                    .padding()
            }

            // Not Now Button
            Button("Not Now") {
                navi.navBack()
            }
            .padding()

            Spacer()
        }
        .padding()
    }

    func createAccount() {
        // Firebase Create User
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // Display error message if creation fails
                createError = "Error: \(error.localizedDescription)"
            } else {
                // On successful account creation, navigate to the game view
                navi.navigate(to: .GameDestination)
            }
        }
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        NewAccountView()
    } else {
        // Fallback on earlier versions
    }
}
