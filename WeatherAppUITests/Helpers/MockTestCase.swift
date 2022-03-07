import XCTest
import Foundation

class MockTestCase: XCTestCase {
    func setupApp(with environment: LaunchEnvironmentKey?) {
        setupApp(with: [environment].compactMap { $0 })
    }

    func setupApp(with environment: [LaunchEnvironmentKey]) {
        setupApp(with: Dictionary(uniqueKeysWithValues: environment.map { ($0.rawValue, "") }))
    }

    func setupApp(with environment: [String: String] = [:]) {
        let app = XCUIApplication()
        app.launchArguments = ["ui-testing-mock"]
        app.launchEnvironment = environment
        continueAfterFailure = false
        app.launch()
    }
}

extension XCUIElement {
    func clearText() {
        guard let stringValue = value as? String else {
            return
        }
        var deleteString = String()
        for _ in stringValue {
            deleteString += XCUIKeyboardKey.delete.rawValue
        }
        typeText(deleteString)
    }
}

extension XCUIElement {
    var elementExists: Bool {
        waitForExistence(timeout: 5)
    }
}
