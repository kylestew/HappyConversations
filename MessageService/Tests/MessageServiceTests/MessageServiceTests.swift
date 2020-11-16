import XCTest
@testable import MessageService

final class MessageServiceTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MessageService().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
