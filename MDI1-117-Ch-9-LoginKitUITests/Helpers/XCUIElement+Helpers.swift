//
//  XCUIElement+Helpers.swift
//  MDI1-117-Ch-9-LoginKit
//
//  Created by Andres de la Cruz on 10/10/26.
//

import XCTest

extension XCUIElement {

    /// Waits until the element exists AND can receive a tap.
    @discardableResult
    func waitUntilHittable(timeout: TimeInterval = 5) -> Bool {
        return self.waitForExistence(timeout: timeout) // 🔴 incomplete — Live Demo fixes this
    }

    /// Waits until a property of the element matches a predicate.
    /// Example: loginButton.wait(until: "isEnabled == true")
    @discardableResult
    func wait(until format: String, timeout: TimeInterval = 5) -> Bool {
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: format),
            object: self
        )
        return XCTWaiter().wait(for: [expectation], timeout: timeout) == .completed
    }

    // TODO (Exercise 9): add `clearAndType(_ text: String)`
    // tap → delete whatever is already in the field → type the new text
}
