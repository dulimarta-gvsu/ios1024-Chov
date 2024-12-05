//
//  SignInView.swift
//  ios1024
//
//  Created by Shawn Chov on 11/21/24.
//

import SwiftUI
import FirebaseAuth

/// View for when attempting to sign in to an existing account
@available(iOS 16.0, *)
struct SignInView: View {
    // Navigator
    @EnvironmentObject var navi: Navigation
    // Vars for email, pass, and errors
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var loginError: String = ""

    var body: some View {
        VStack {
            Text("Sign In")
                .font(.largeTitle)
                .padding()

            // Email TextField
            TextField("Email", text: $email)
                .padding()
                .keyboardType(.emailAddress) // Catered for emails
                .textInputAutocapitalization(.never) // No auto capitalize
                .disableAutocorrection(true) // No autocorrect
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal)

            // Password SecureField
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal)

            // Sign In Button
            Button("Sign In") {
                signIn()
            }
            .buttonStyle(.borderedProminent)
            .padding()

            // Error Message
            if !loginError.isEmpty {
                Text(loginError)
                    .foregroundColor(.red)
                    .padding()
            }

            Spacer()
        }
        .padding()
    }

    func signIn() {
        // Firebase Authentication
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // Display the error message if authentication fails
                loginError = "Error: \(error.localizedDescription)"
            } else {
                // On successful login, navigate to the main game screen
                navi.navigate(to: .GameDestination)
            }
        }
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        SignInView()
    } else {
        // Fallback on earlier versions
    }
}
