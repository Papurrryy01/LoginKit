//
//  DashboardScreen.swift
//  LoginKit
//
//  Created by Carlos Vera on 10/10/26.
//

import XCTest

struct DashboardScreen {
    let app: XCUIApplication

    var welcomeLabel: XCUIElement { app.staticTexts["welcome_label"] }
    var logoutButton: XCUIElement { app.buttons["logout_button"] }

    @discardableResult
    func logout() -> Self {
        XCTAssertTrue(logoutButton.waitUntilHittable())
        logoutButton.tap()
        return self
    }
}
