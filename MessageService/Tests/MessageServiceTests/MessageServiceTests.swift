import XCTest
import DVR
@testable import MessageService

final class MessageServiceTests: XCTestCase {

    var requiredHandle: Any?

    func testFetchMessages() {
        let expectation = XCTestExpectation(description: "Fetch messages from server")

        let expectedMessage = MessageService.Message(user: "kyle",
                                                     subject: "pets",
                                                     message: "My dog, Harlowe, is the goodest boy.")

        let replaySession = Session(cassetteName: "Fixtures/fetch_messages", testBundle: Bundle.module)
        let service = MessageService(session: replaySession)
        requiredHandle = service.fetch { result in
            switch result {
            case .success(let response):
                // should respond with 200 OK
                XCTAssertEqual(response.statusCode, 200)

                // should contain expected message
                XCTAssertTrue(response.messages.contains(expectedMessage))

            case .failure(let error):
                // possibly a coding error
                XCTFail(error.localizedDescription)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10)
    }

    func testFetchErrorCase() {
        let expectation = XCTestExpectation(description: "Should emit proper error for invalid request")

        let badUrl = URL(string: "https://abraxvasbh.execute-api.us-east-2.amazonaws.com/bad-url")!
        let service = MessageService(baseURL: badUrl)
        requiredHandle = service.fetch { result in
            switch result {
            case .success(_):
                XCTFail("No, Mr Bond, I expect you to die!")

            case .failure(let error):
                // should fail due to bad status code return
                XCTAssertEqual(error, MessageService.ServiceError.invalidStatusCode)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10)
    }

    func testPostMessage() {
        let expectation = XCTestExpectation(description: "Should post message data to server")

        let message = MessageService.Message.init(
            user: "kyle",
            subject: "pets",
            message: "My dog, Harlowe, is the goodest boy.")

        let replaySession = Session(cassetteName: "Fixtures/post_message", testBundle: Bundle.module)
        let service = MessageService(session: replaySession)

        requiredHandle = service.post(message) { result in
            switch result {
            case .success(let response):
                // should response with 200 OK
                XCTAssertEqual(response.statusCode, 200)

            case .failure(let error):
                // possibly a coding error
                XCTFail(error.localizedDescription)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10)
    }

    func testFetchSingleMessage() {
        let expectation = XCTestExpectation(description: "Fetch messages from server for a specific user")

        let username = "kyle"
        let expectedMessage = MessageService.Message(user: "kyle",
                                                     subject: "pets",
                                                     message: "My dog, Harlowe, is the goodest boy.")

        let replaySession = Session(cassetteName: "Fixtures/fetch_user_messages", testBundle: Bundle.module)
        let service = MessageService(session: replaySession)
        requiredHandle = service.fetch(username: username) { result in
            switch result {
            case .success(let response):
                // should response with 200 OK
                XCTAssertEqual(response.statusCode, 200)

                // should respond with specific message
                XCTAssertTrue(response.messages.contains(expectedMessage))

            case .failure(let error):
                // possibly a coding error
                XCTFail(error.localizedDescription)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10)
    }

    static var allTests = [
        ("testFetchMessages", testFetchMessages),
        ("testFetchErrorCase", testFetchErrorCase),
        ("testPostMessage", testPostMessage),
        ("testFetchSingleMessage", testFetchSingleMessage),
    ]
}
