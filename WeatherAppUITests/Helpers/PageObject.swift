import XCTest

@MainActor protocol PageObject {
    var sceneId: String { get }
    var isOnPage: Bool { get }
}

@MainActor extension PageObject {
    static var proxy: XCUIApplication { XCUIApplication() }
    var sceneElement: XCUIElement { Self.proxy.otherElements[sceneId] }

    /// Checks if the scene is the front most, by checking that it exists and is hittable.
    var isOnPage: Bool { sceneElement.elementExists && sceneElement.isHittable }

    /// Checks if the scene exists but is not at the front, for instance is under an alert dialog.
    /// Note: this does not validate that the scene is currently visible, it can be under some other scene.
    var isOnPageNotHittable: Bool { sceneElement.elementExists && !sceneElement.isHittable }

    /// Returns a keyboard element query.
    var keyboard: XCUIElement { Self.proxy.keyboards.element }
}

@MainActor extension XCTestCase {
    func waitForElementToAppear(_ element: XCUIElement) {
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }

    func waitForElementToDisappear(_ element: XCUIElement) {
        let existsPredicate = NSPredicate(format: "exists == false")
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
}
