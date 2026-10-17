//
//  MDI1_117_Ch_9_LoginKitTests.swift
//  Created by Carlos Vera on 10/7/26.
//

import Foundation
import Testing
@testable import MDI1_117_Ch_9_LoginKit

@MainActor
struct LoginViewModelTests {
    @Test(arguments: ["", "   ", "\n"])
    func blankEmailDoesNotAuthenticate(email: String) async {
        let service = StubAuthService()
        let model = LoginViewModel(authService: service, sessionStore: MemorySessionStore())
        model.email = email
        model.password = "test1234"
        await model.login()
        #expect(!model.canLogin)
        #expect(service.calls == 0)
    }

    @Test func emptyPasswordDoesNotAuthenticate() async {
        let service = StubAuthService()
        let model = LoginViewModel(authService: service, sessionStore: MemorySessionStore())
        model.email = "test@mail.com"
        await model.login()
        #expect(service.calls == 0)
    }

    @Test func threeFailuresLockOutAndRecoveryAllowsRetry() async {
        let service = StubAuthService()
        service.error = AuthError.invalidCredentials
        let model = LoginViewModel(authService: service, sessionStore: MemorySessionStore(), lockoutDuration: .zero)
        model.email = "wrong@mail.com"
        model.password = "wrong"
        for _ in 0..<3 { await model.login() }
        #expect(model.isLockedOut)
        #expect(!model.canLogin)
        #expect(model.errorMessage == "Too many attempts. Try again later.")
        await model.login()
        #expect(service.calls == 3)
        await model.recoverFromLockout()
        #expect(model.canLogin)
        #expect(model.failedAttempts == 0)
        service.error = nil
        await model.login()
        #expect(model.loggedInUser != nil)
    }

    @Test func successfulLoginResetsFailuresAndRemembersSubmittedEmail() async {
        let service = StubAuthService()
        let storage = MemorySessionStore()
        let model = LoginViewModel(authService: service, sessionStore: storage)
        model.email = " test@mail.com "
        model.password = "test1234"
        model.rememberMe = true
        service.error = AuthError.invalidCredentials
        await model.login()
        service.error = nil
        await model.login()
        #expect(model.failedAttempts == 0)
        #expect(storage.rememberedEmail == "test@mail.com")
        #expect(service.lastEmail == "test@mail.com")
        model.logout()
        #expect(model.password.isEmpty)
        #expect(model.loggedInUser == nil)
        let restored = LoginViewModel(authService: service, sessionStore: storage)
        #expect(restored.email == "test@mail.com")
        #expect(restored.rememberMe)
    }

    @Test func optingOutClearsRememberedEmail() async {
        let storage = MemorySessionStore()
        storage.rememberedEmail = "old@mail.com"
        let model = LoginViewModel(authService: StubAuthService(), sessionStore: storage)
        model.password = "test1234"
        model.rememberMe = false
        await model.login()
        #expect(storage.rememberedEmail == nil)
        model.logout()
        #expect(model.email.isEmpty)
    }

    @Test func cancellationAndNetworkErrorsDoNotCountAsInvalidCredentials() async {
        let service = StubAuthService()
        let model = LoginViewModel(authService: service, sessionStore: MemorySessionStore())
        model.email = "test@mail.com"
        model.password = "test1234"
        service.error = CancellationError()
        await model.login()
        #expect(model.errorMessage == nil)
        service.error = URLError(.notConnectedToInternet)
        await model.login()
        #expect(model.errorMessage != nil)
        #expect(model.failedAttempts == 0)
        #expect(!model.isLoading)
    }

    @Test func concurrentLoginIsIgnored() async {
        let service = SuspendedAuthService()
        let storage = MemorySessionStore()
        let model = LoginViewModel(authService: service, sessionStore: storage)
        model.email = "test@mail.com"
        model.password = "test1234"
        model.rememberMe = true
        let first = Task { await model.login() }
        while service.continuation == nil { await Task.yield() }
        #expect(model.isLoading)
        await model.login()
        #expect(service.calls == 1)
        model.email = "changed@mail.com"
        service.continuation?.resume(returning: User(email: "test@mail.com", name: "Test User"))
        await first.value
        #expect(storage.rememberedEmail == "test@mail.com")
        #expect(!model.isLoading)
    }
}

private final class MemorySessionStore: SessionStoring {
    var rememberedEmail: String?
    func clear() { rememberedEmail = nil }
}

@MainActor
private final class StubAuthService: AuthServiceProtocol {
    var calls = 0
    var lastEmail: String?
    var error: Error?
    func login(email: String, password: String) async throws -> User {
        calls += 1
        lastEmail = email
        if let error { throw error }
        return User(email: email, name: "Test User")
    }
}

@MainActor
private final class SuspendedAuthService: AuthServiceProtocol {
    var calls = 0
    var continuation: CheckedContinuation<User, Error>?
    func login(email: String, password: String) async throws -> User {
        calls += 1
        return try await withCheckedThrowingContinuation { continuation = $0 }
    }
}
