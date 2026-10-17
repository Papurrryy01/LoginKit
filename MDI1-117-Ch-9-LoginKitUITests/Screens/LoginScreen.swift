//
//  LoginScreen.swift
//  LoginKit
//
//  Created by Carlos Vera on 10/10/26.
//

import XCTest

struct LoginScreen {
    let app: XCUIApplication

    var emailField: XCUIElement { app.textFields["email_field"] }
    var passwordField: XCUIElement { app.secureTextFields["password_field"] }
    var loginButton: XCUIElement { app.buttons["login_button"] }
    var errorLabel: XCUIElement { app.staticTexts["error_label"] }
    var rememberMe: XCUIElement { app.switches["remember_me_toggle"] }

    @discardableResult
    func login(email: String, password: String, rememberMe: Bool = false) -> Self {
        setRememberMe(rememberMe)
        emailField.clearAndType(email)
        passwordField.clearAndType(password)
        XCTAssertTrue(loginButton.waitUntilHittable())
        loginButton.tap()
        return self
    }

    @discardableResult
    func setRememberMe(_ on: Bool) -> Self {
        XCTAssertTrue(rememberMe.waitUntilHittable())
        let isOn = (rememberMe.value as? String) == "1"
        if isOn != on {
            rememberMe.coordinate(withNormalizedOffset: CGVector(dx: 0.92, dy: 0.5)).tap()
        }
        return self
    }

}
