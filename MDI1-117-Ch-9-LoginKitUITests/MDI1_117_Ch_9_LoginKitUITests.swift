//
//  MDI1_117_Ch_9_LoginKitUITests.swift
//  MDI1-117-Ch-9-LoginKitUITests
//
//  Created by Andres de la Cruz on 10/7/26.
//

import XCTest

final class MDI1_117_Ch_9_LoginKitUITests: XCTestCase {

    // MARK: Class #4 UI Testing
    
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

    // MARK: Simple implementation
    /// Test #1 - Navigate to dashboard
//    func test_successfulLogin_navigatesToDashboard() throws {
//        let app = XCUIApplication()
//        app.launchArguments = ["-UITesting-Reset"]
//        app.launch()
//        
//        let emailField = app.textFields["email_field"]
//        emailField.tap()
//        emailField.typeText("test@mail.com")
//        
//        let passwordField = app.secureTextFields["password_field"]
//        passwordField.tap()
//        passwordField.typeText("test1234")
//        
//        app.buttons["login_button"].tap()
//        
//        XCTAssertTrue(app.staticTexts["welcome_label"].waitForExistence(timeout: 5))
//    }
    
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
