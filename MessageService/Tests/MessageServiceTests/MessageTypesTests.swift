import XCTest
import SwiftyJSON
@testable import MessageService

final class MessageTypesTests: XCTestCase {

    func testParseJSONtoMessages() {
        let jsonString =
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

        let expectedMessage = MessageService.Message(user: "kyle", subject: "pets", message: "My dog is the goodest boy.")

        let json = JSON.init(parseJSON: jsonString)
        let messageResponse = MessageService.MessageResponseData(statusCode: 200, body: json)

        XCTAssertEqual(messageResponse.messages.count, 3)
        XCTAssertTrue(messageResponse.messages.contains(expectedMessage))
    }

    static var allTests = [
        ("testParseJSONtoMessages", testParseJSONtoMessages),
    ]
}
