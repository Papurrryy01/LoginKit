//
//  FlakyUITests.swift
//  MDI1-117-Ch-9-LoginKit
//
//  Created by Andres de la Cruz on 10/10/26.
//

import XCTest

final class FlakyUITests: XCTestCase {

    // MARK: Class #5 Flaky-Free UI Testing

    var app: XCUIApplication!
    var loginScreen: LoginScreen!
    var dashboardScreen: DashboardScreen!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        // TODO (Exercise 3): disable animations with a launch argument
        // TODO (Exercise 5): reset the app state before every test
        app.launchArguments = []
        app.launch()
        loginScreen = LoginScreen(app: app)
        dashboardScreen = DashboardScreen(app: app)
    }

    /// Live Demo — Timing / animations
    func test_logoutImmediatelyAfterLogin_isFlaky() throws {
        loginScreen.login(email: "test@mail.com", password: "test1234")
        XCTAssertTrue(dashboardScreen.welcomeLabel.waitForExistence(timeout: 5))

        dashboardScreen.logoutButton.tap() // 🔴 the button may not be ready yet

        XCTAssertTrue(loginScreen.emailField.waitForExistence(timeout: 5))
    }

    /// Exercise 4 — Arbitrary sleep
    func test_successfulLogin_arbitrarySleep_isFlaky() throws {
        loginScreen.login(email: "test@mail.com", password: "test1234")

        Thread.sleep(forTimeInterval: 0.45) // 🔴 fix me

        XCTAssertTrue(dashboardScreen.welcomeLabel.exists)
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
