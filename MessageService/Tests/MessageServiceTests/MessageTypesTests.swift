import XCTest
import SwiftyJSON
@testable import MessageService

final class MessageTypesTests: XCTestCase {

    let allMessagesByUsersJSON =
    """
    {
        "kyle": [
        {
            "subject": "pets",
            "message": "My dog is the goodest boy."
        },
        {
            "subject": "pets",
            "message": "His name is Harlowe"
        }],
        "angry_bob": [
        {
            "subject": "pets",
            "message": "My dog is better than yours!",
        }]
    }
    """

    let messagesForSingleUserJSON =
    """
    {
        "user": "kyle",
        "message": [
        {
            "subject": "pets",
            "message": "My dog is the goodest boy."
        },
        {
            "subject": "pets",
            "message": "His name is Harlowe"
        }]
    }
    """

    func testParseAllMessages() {
        let expectedMessage = MessageService.Message(user: "kyle", subject: "pets", message: "My dog is the goodest boy.")

        let json = JSON.init(parseJSON: allMessagesByUsersJSON)
        let messageResponse = MessageService.MessageResponseData(statusCode: 200, body: json)

        XCTAssertEqual(messageResponse.messages.count, 3)
        XCTAssertTrue(messageResponse.messages.contains(expectedMessage))
    }

    func testParseMessagesByUser() {
    let expectedMessage = MessageService.Message(user: "kyle", subject: "pets", message: "His name is Harlowe")

        let json = JSON.init(parseJSON: allMessagesByUsersJSON)
        let messageResponse = MessageService.MessageResponseData(statusCode: 200, body: json)

        let messagesByUser = messageResponse.messagesByUser()
        XCTAssertEqual(messagesByUser.keys.count, 2)
        XCTAssertNotNil(messagesByUser["kyle"])
        if let messagesForKyle = messagesByUser["kyle"] {
            XCTAssertTrue(messagesForKyle.contains(expectedMessage))
        }
    }

    func testParseMessagesForUser() {
        let expectedMessage = MessageService.Message(user: "kyle", subject: "pets", message: "His name is Harlowe")

        let json = JSON.init(parseJSON: messagesForSingleUserJSON)
        let messageResponse = MessageService.MessageResponseData(statusCode: 200, body: json)

        XCTAssertEqual(messageResponse.messages.count, 2)
        XCTAssertTrue(messageResponse.messages(for: expectedMessage.user).contains(expectedMessage))
    }

    static var allTests = [
        ("testParseAllMessages", testParseAllMessages),
        ("testParseMessagesByUser", testParseMessagesByUser),
        ("testParseMessagesForUser", testParseMessagesForUser),
    ]
}
