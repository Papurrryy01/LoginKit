//
//  XCUIElement+Helpers.swift
//  Created by Carlos Vera on 10/17/26.
//

import XCTest
import XCUIAutomation

extension XCUIElement {
    @discardableResult
    func waitUntilHittable(timeout: TimeInterval = 5) -> Bool {
        wait(until: "exists == true AND hittable == true AND enabled == true", timeout: timeout)
    }

    @discardableResult
    func wait(until format: String, timeout: TimeInterval = 5) -> Bool {
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: format), object: self
        )
        return XCTWaiter().wait(for: [expectation], timeout: timeout) == .completed
    }

    func clearAndType(_ text: String, file: StaticString = #filePath, line: UInt = #line) {
        guard waitUntilHittable() else {
            XCTFail("Field is not ready for input: \(identifier)", file: file, line: line)
            return
        }
        tap()
        // Select all works with both secure and plain fields, without counting masked characters.
        typeKey("a", modifierFlags: .command)
        typeText(XCUIKeyboardKey.delete.rawValue)
        if !text.isEmpty {
            typeText(text)
        }
    }
}
