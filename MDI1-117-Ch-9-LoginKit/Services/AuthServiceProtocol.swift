//
//  AuthServiceProtocol.swift
//  MDI1-117-Ch-9-LoginKit
//
//  Created by Andres de la Cruz on 10/7/26.
//

import Foundation
 
protocol AuthServiceProtocol {
    func login(email: String, password: String) async throws -> User
}
 
enum AuthError: Error, LocalizedError {
    case invalidCredentials
 
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        }
    }
}
 
