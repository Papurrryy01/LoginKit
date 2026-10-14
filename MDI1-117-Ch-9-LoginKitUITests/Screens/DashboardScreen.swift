//
//  DashboardScreen.swift
//  MDI1-117-Ch-9-LoginKit
//
//  Created by Andres de la Cruz on 10/7/26.
//
 
import XCTest

struct DashboardScreen {
    let app: XCUIApplication
    
    var welcomeLabel: XCUIElement { app.staticTexts["welcome_label"] }
    var logoutButton: XCUIElement { app.buttons["logout_button"] }
    
    @discardableResult
    func logout() -> Self {
        logoutButton.tap()
        return self
    }
}
