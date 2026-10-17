//
//  LoginViewModel.swift
//  Created by Carlos Vera on 10/7/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class LoginViewModel {
    var email = ""
    var password = ""
    var rememberMe = false
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    var loggedInUser: User?
    private(set) var failedAttempts = 0
    private(set) var isLockedOut = false

    private let authService: AuthServiceProtocol
    private var sessionStore: SessionStoring
    private let lockoutDuration: Duration

    var canLogin: Bool {
        !isLoading && !isLockedOut &&
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.isEmpty
    }

    init(authService: AuthServiceProtocol,
         sessionStore: SessionStoring = SessionStore(),
         lockoutDuration: Duration = .seconds(30)) {
        self.authService = authService
        self.sessionStore = sessionStore
        self.lockoutDuration = lockoutDuration
        if let rememberedEmail = sessionStore.rememberedEmail {
            email = rememberedEmail
            rememberMe = true
        }
    }

    func login() async {
        guard canLogin else { return }
        // Capture the submitted values before suspension so persistence matches this request.
        let submittedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let submittedPassword = password
        let shouldRemember = rememberMe
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            let user = try await authService.login(email: submittedEmail, password: submittedPassword)
            try Task.checkCancellation()
            failedAttempts = 0
            loggedInUser = user
            if shouldRemember {
                sessionStore.rememberedEmail = submittedEmail
            } else {
                sessionStore.clear()
            }
        } catch is CancellationError {
            // Cancellation is not a failed credential attempt.
        } catch AuthError.invalidCredentials {
            failedAttempts += 1
            isLockedOut = failedAttempts >= 3
            errorMessage = isLockedOut
                ? "Too many attempts. Try again later."
                : AuthError.invalidCredentials.localizedDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // The view owns this cancellable task; no detached timer retains the model.
    func recoverFromLockout() async {
        guard isLockedOut else { return }
        do {
            try await Task.sleep(for: lockoutDuration)
        } catch {
            return
        }
        failedAttempts = 0
        isLockedOut = false
        errorMessage = nil
    }

    func logout() {
        loggedInUser = nil
        password = ""
        errorMessage = nil
        if !rememberMe {
            email = ""
        }
    }
}
