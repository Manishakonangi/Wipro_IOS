import Foundation
import SwiftUI
import Combine
import LocalAuthentication

@MainActor
class AuthenticationViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var isAuthenticated = false
    @Published var username = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var isLoading = false

    // MARK: - Manual Login

    func login(username: String, password: String) {

        let enteredUsername = username.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let enteredPassword = password.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        errorMessage = ""

        guard !enteredUsername.isEmpty else {
            errorMessage = "Please enter your username."
            return
        }

        guard !enteredPassword.isEmpty else {
            errorMessage = "Please enter your password."
            return
        }

        // Demo login credentials

        if enteredUsername == "admin" &&
            enteredPassword == "123456" {

            isAuthenticated = true
            errorMessage = ""

        } else {

            isAuthenticated = false
            errorMessage = "Invalid username or password."
        }
    }

    // MARK: - Face ID Authentication

    func authenticateWithFaceID() async {

        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(
            .deviceOwnerAuthentication,
            error: &error
        ) else {
            errorMessage = "Authentication unavailable. Please login manually."
            return
        }

        isLoading = true

        defer {
            isLoading = false
        }

        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthentication,
                localizedReason: "Authenticate to access your medicines"
            )

            if success {
                isAuthenticated = true
                errorMessage = ""
            }

        } catch {
            isAuthenticated = false
            errorMessage = "Authentication failed. Please login manually."
        }
    }

    // MARK: - Logout

    func logout() {

        isAuthenticated = false
        username = ""
        password = ""
        errorMessage = ""
    }
}
