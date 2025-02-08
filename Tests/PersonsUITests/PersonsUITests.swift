import XCTest

@MainActor
final class PersonsUITests: XCTestCase {
    private func launchApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["UI_TESTS"]
        app.launch()
        return app
    }

    func testPersonDetails() throws {
        let app = launchApp()

        app.buttons["Ann Smith"].tap()

        XCTAssertTrue(app.staticTexts["id: 0"].exists)
    }
}
