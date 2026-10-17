//
//  LoginViewModel.swift
//  MDI1-117-Ch-9-LoginKit
//
//  Created by Carlos Vera on 10/7/26.
//

import Foundation
import Combine
 
@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var rememberMe: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var loggedInUser: User?
 
    private let authService: AuthServiceProtocol
    private var sessionStore: SessionStoring
 
    init(authService: AuthServiceProtocol, sessionStore: SessionStoring = SessionStore()) {
        self.authService = authService
        self.sessionStore = sessionStore
 
        if let rememberedEmail = sessionStore.rememberedEmail {
            self.email = rememberedEmail
            self.rememberMe = true
        }
    }
 
    func login() async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }
 
        do {
            let user = try await authService.login(email: email, password: password)
            loggedInUser = user
 
            if rememberMe {
                sessionStore.rememberedEmail = email
            } else {
                sessionStore.clear()
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
 
    func logout() {
        loggedInUser = nil
        password = ""
        if !rememberMe {
            email = ""
        }
    }
}
