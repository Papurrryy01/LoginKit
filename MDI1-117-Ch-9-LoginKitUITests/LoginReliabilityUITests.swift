//
//  LoginReliabilityUITests.swift
//  LoginKit
//
//  Created by Carlos Vera on 10/10/26.
//

import XCTest

final class LoginReliabilityUITests: XCTestCase {

    // MARK: Class #5 Flaky-Free UI Testing

    var app: XCUIApplication!
    var loginScreen: LoginScreen!
    var dashboardScreen: DashboardScreen!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-UITesting-Reset", "-UITesting-NoAnimations"]
        app.launch()
        loginScreen = LoginScreen(app: app)
        dashboardScreen = DashboardScreen(app: app)
    }

    /// Live Demo — Timing / animations
    func test_logoutWaitsForActions() throws {
        loginScreen.login(email: "test@mail.com", password: "test1234")
        XCTAssertTrue(dashboardScreen.welcomeLabel.waitForExistence(timeout: 5))

        dashboardScreen.logout()

        XCTAssertTrue(loginScreen.emailField.waitForExistence(timeout: 5))
    }

    /// Exercise 4 — Arbitrary sleep
    func test_successfulLogin_waitsForDashboard() throws {
        loginScreen.login(email: "test@mail.com", password: "test1234")
        XCTAssertTrue(dashboardScreen.welcomeLabel.waitForExistence(timeout: 5))
    }

    /// Exercise 5 — Shared state
    func test_rememberMe_persistsEmailAcrossRelaunch() throws {
        loginScreen.login(email: "test@mail.com", password: "test1234", rememberMe: true)
        XCTAssertTrue(dashboardScreen.welcomeLabel.waitForExistence(timeout: 5))

        app.terminate()
        // Relaunch WITHOUT the reset, so the remembered email survives
        app.launchArguments.removeAll { $0 == "-UITesting-Reset" }
        app.launch()

        XCTAssertTrue(loginScreen.emailField.waitForExistence(timeout: 5))
        XCTAssertEqual(loginScreen.emailField.value as? String, "test@mail.com")
    }
}
