import SwiftUI

struct AuthenticationView: View {

    @StateObject private var viewModel = AuthenticationViewModel()

    var body: some View {

        Group {

            // Navigate to Dashboard after successful login
            if viewModel.isAuthenticated {

                MainTabView()

            } else {

                NavigationStack {

                    VStack(spacing: 25) {

                        Spacer()

                        Image(systemName: "pills.circle.fill")
                            .font(.system(size: 85))
                            .foregroundColor(.blue)

                        Text("Daily Medicine Tracker")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)

                        Text("Secure access to your medicines")
                            .foregroundColor(.secondary)

                        // Username
                        VStack(alignment: .leading, spacing: 8) {

                            Text("Username")
                                .fontWeight(.semibold)

                            TextField(
                                "Enter username",
                                text: $viewModel.username
                            )
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        }

                        // Password
                        VStack(alignment: .leading, spacing: 8) {

                            Text("Password")
                                .fontWeight(.semibold)

                            SecureField(
                                "Enter password",
                                text: $viewModel.password
                            )
                            .textFieldStyle(.roundedBorder)
                        }

                        // Error Message
                        if !viewModel.errorMessage.isEmpty {

                            Text(viewModel.errorMessage)
                                .foregroundColor(.red)
                                .font(.footnote)
                        }

                        // Manual Login
                        Button {

                            viewModel.login(
                                username: viewModel.username,
                                password: viewModel.password
                            )

                        } label: {

                            Text("Login")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                        }

                        // Face ID Login
                        Button {

                            Task {
                                await viewModel.authenticateWithFaceID()
                            }

                        } label: {

                            Label(
                                "Login with Face ID",
                                systemImage: "faceid"
                            )
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                        }

                        Spacer()

                        Text("Stay healthy, stay safe!")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    .padding(25)
                    .navigationBarHidden(true)
                }
            }
        }
    }
}

#Preview {
    AuthenticationView()
}
