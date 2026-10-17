//
//  AuthService.swift
//  MDI1-117-Ch-9-LoginKit
//
//  Created by Carlos Vera on 10/7/26.
//

import Foundation
 
final class AuthService: AuthServiceProtocol {
    private let validEmail = "test@mail.com"
    private let validPassword = "test1234"
 
    func login(email: String, password: String) async throws -> User {
        try await Task.sleep(nanoseconds: 400_000_000)
 
        guard email == validEmail, password == validPassword else {
            throw AuthError.invalidCredentials
        }
        return User(email: email, name: "Example")
    }
}
 
