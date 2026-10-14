//
//  FeatureUITests.swift
//  MDI1-117-Ch-9-LoginKit
//
//  Created by Andres de la Cruz on 10/10/26.
//

import XCTest

/// These tests are the SPEC. They fail until you build the feature.
final class FeatureUITests: XCTestCase {

    var app: XCUIApplication!
    var loginScreen: LoginScreen!
    var dashboardScreen: DashboardScreen!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-UITesting-Reset"]
        app.launch()
        loginScreen = LoginScreen(app: app)
        dashboardScreen = DashboardScreen(app: app)
    }

    /// Exercise 7 — Disabled Login button
    func test_loginButton_disabledUntilFieldsAreFilled() throws {
        XCTAssertTrue(loginScreen.emailField.waitForExistence(timeout: 5))
        XCTAssertFalse(loginScreen.loginButton.isEnabled)

        loginScreen.emailField.tap()
        loginScreen.emailField.typeText("test@mail.com")
        XCTAssertFalse(loginScreen.loginButton.isEnabled) // password still empty

        loginScreen.passwordField.tap()
        loginScreen.passwordField.typeText("test1234")
        XCTAssertTrue(loginScreen.loginButton.isEnabled)
    }

    /// Exercise 8 — Show / hide password
    func test_passwordVisibilityToggle_showsAndHidesPassword() throws {
        XCTAssertTrue(loginScreen.passwordField.waitForExistence(timeout: 5))
        loginScreen.passwordField.tap()
        loginScreen.passwordField.typeText("test1234")

        app.buttons["toggle_password_visibility"].tap()

        let visiblePassword = app.textFields["password_field"]
        XCTAssertTrue(visiblePassword.waitForExistence(timeout: 5))
        XCTAssertEqual(visiblePassword.value as? String, "test1234")
    }

    /// Exercise 9 — Defensive Page Object
    func test_login_withRememberedEmail_stillSucceeds() throws {
        loginScreen.login(email: "test@mail.com", password: "test1234", rememberMe: true)
        XCTAssertTrue(dashboardScreen.welcomeLabel.waitForExistence(timeout: 5))
        dashboardScreen.logout()

        // Remember Me is on, so the email field is NOT empty anymore
        loginScreen.login(email: "test@mail.com", password: "test1234")
        XCTAssertTrue(dashboardScreen.welcomeLabel.waitForExistence(timeout: 5))
    }

    /// Exercise 11 — Lockout after 3 failed attempts
    func test_threeFailedLogins_locksTheLoginButton() throws {
        for _ in 1...2 {
            loginScreen.login(email: "wrong@mail.com", password: "nope")
            XCTAssertTrue(loginScreen.loginButton.wait(until: "isEnabled == true"))
        }

        loginScreen.login(email: "wrong@mail.com", password: "nope")

        XCTAssertTrue(loginScreen.errorLabel.wait(until: "label == 'Too many attempts. Try again later.'"))
        XCTAssertFalse(loginScreen.loginButton.isEnabled)
    }
}
