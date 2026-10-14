//
//  AuthService.swift
//  MDI1-117-Ch-9-LoginKit
//
//  Created by Andres de la Cruz on 10/7/26.
//

import Foundation
 
final class AuthService: AuthServiceProtocol {
    private let validEmail = "test@mail.com"
    private let validPassword = "test1234"
 
    func login(email: String, password: String) async throws -> User {
        // Simulates real network latency: a server never answers in the same time
        try await Task.sleep(for: .milliseconds(Int.random(in: 300...900)))
 
        guard email == validEmail, password == validPassword else {
            throw AuthError.invalidCredentials
        }
        return User(email: email, name: "Example")
    }
}
 
