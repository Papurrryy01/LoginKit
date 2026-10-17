//  LoginKitUITests.swift
//  LoginKitUITests
//  Created by Carlos Vera on 10/10/26.

import XCTest

final class LoginKitUITests: XCTestCase {

    // MARK: Class #4 UI Testing

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


    /// Test #1 - Navigate to dashboard
    func test_successfulLogin_navigatesToDashboard() throws {
        loginScreen.login(email: "test@mail.com", password: "test1234")
        XCTAssertTrue(dashboardScreen.welcomeLabel.waitForExistence(timeout: 5))
    }

    /// Test #2 - Failure Path
    func test_invalidLogin_showsErrorMessage() throws {
        loginScreen.login(email: "testerror@mail.com", password: "1234test")
        XCTAssertTrue(loginScreen.errorLabel.waitForExistence(timeout: 5))
        XCTAssertFalse(dashboardScreen.welcomeLabel.exists)
    }

    /// Test #3 - Logout
    func test_logout_returnsToLoginScreen() throws {
        loginScreen.login(email: "test@mail.com", password: "test1234")
        XCTAssertTrue(dashboardScreen.welcomeLabel.waitForExistence(timeout: 5))

        dashboardScreen.logout()

        XCTAssertTrue(loginScreen.emailField.waitForExistence(timeout: 5))
        XCTAssertFalse(dashboardScreen.welcomeLabel.exists)
    }
}
