//
//  LoginView.swift
//  LoginKit
//
//  Created by Carlos Vera on 10/10/26.
//

import SwiftUI

struct LoginView: View {
    @State private var viewModel: LoginViewModel
    @State private var showPassword = false

    init(authService: AuthServiceProtocol = AuthService()) {
        _viewModel = State(initialValue: LoginViewModel(authService: authService))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("LoginKit")
                    .font(.largeTitle.bold())

                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(.roundedBorder)
                    #if os(iOS) || os(visionOS)
                    .textInputAutocapitalization(.never)
                    #endif
                    .autocorrectionDisabled()
                    .accessibilityIdentifier("email_field")


                HStack {
                    if showPassword {
                        TextField("Password", text: $viewModel.password)
                            .textFieldStyle(.roundedBorder)
                            .accessibilityIdentifier("password_field")
                    } else {
                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(.roundedBorder)
                            .accessibilityIdentifier("password_field")
                    }

                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                    }
                    .accessibilityIdentifier("toggle_password_visibility")
                    .accessibilityLabel(showPassword ? "Hide password" : "Show password")
                }

                Toggle("Remember Me", isOn: $viewModel.rememberMe)
                    .accessibilityIdentifier("remember_me_toggle")

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .accessibilityIdentifier("error_label")
                }

                Button {
                    Task { await viewModel.login() }
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                            .accessibilityIdentifier("loading_indicator")
                    } else {
                        Text("Log In")
                    }
                }
                .accessibilityIdentifier("login_button")
                .disabled(!viewModel.canLogin)
            }
            .padding()
            .task(id: viewModel.isLockedOut) {
                await viewModel.recoverFromLockout()
            }
            .transaction { transaction in
                if ProcessInfo.processInfo.arguments.contains("-UITesting-NoAnimations") {
                    transaction.disablesAnimations = true
                }
            }
            .navigationDestination(item: $viewModel.loggedInUser) { user in
                DashboardView(user: user, onLogout: { viewModel.logout() })
            }
        }
    }
}
