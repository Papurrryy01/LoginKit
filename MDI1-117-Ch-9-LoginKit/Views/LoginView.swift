//
//  LoginView.swift
//  MDI1-117-Ch-9-LoginKit
//
//  Created by Carlos Vera on 10/7/26.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel

    init(authService: AuthServiceProtocol = AuthService()) {
        _viewModel = StateObject(wrappedValue: LoginViewModel(authService: authService))
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

                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityIdentifier("password_field")

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
                .disabled(viewModel.isLoading)
            }
            .padding()
            .navigationDestination(item: $viewModel.loggedInUser) { user in
                DashboardView(user: user, onLogout: { viewModel.logout() })
            }
        }
    }
}
