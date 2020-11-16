import XCTest
@testable import MessageService

final class MessageServiceTests: XCTestCase {

    func testFetchMessages() {
        // Create an expectation for a background download task.
        let expectation = XCTestExpectation(description: "Fetch messages from server")

        let service = MessageService()
        let requiredHandle = service.fetch { result in
            XCTAssertEqual(result.statusCode, 200)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10)
    }

    func testFetchErrorCase() {
    }

    static var allTests = [
        ("testFetchMessages", testFetchMessages),
    ]
}
