import Foundation
import SwiftyJSON

extension MessageService {

    /**
     ## MessageResponseData

     All API calls return `MessageResponseData`. The original blog of JSON provided in the response body parameter is not meant for the client. Instead use the `messages` array, and various helper functions designed to sort and group messages for client display.

     */
    public struct MessageResponseData {

        let body: JSON

        /// HTTP response code sent with server response (also in HTTP headers)
        public let statusCode: Int

        /// all parsable messages from server response body (in standardized format)
        public let messages: [Message]

        init(statusCode: Int, body: JSON) {
            self.statusCode = statusCode
            self.body = body

            var messages = [Message]()
            if body["message"].exists() && body["user"].exists() {
                // parse as messages FOR SINGLE user data structure
                let user = body["user"].stringValue
                messages.append(contentsOf: body["message"].arrayValue.map { Message(user: user, json: $0) })
            } else {
                // parse as messages BY user data structure
                for (user, messageData) in body {
                    messages.append(contentsOf: messageData.arrayValue.map { Message(user: user, json: $0) })
                }
            }
            self.messages = messages
        }

        /// Returns: messages for a specific user only
        public func messages(for user: String) -> [Message] {
            messages.filter { $0.user == user }
        }

        /// Returns: list of messages groupe by users
        public func messagesByUser() -> [String: [Message]] {
            Dictionary(grouping: messages) { $0.user }
        }
    }

    /**
     ## Message

     The reason this service exists, to communicate with others! These bite size morsels of knowledge and connection contain:
     As a convenience `Message`s know how to create from and store themselves to SwiftyJSON objects.

     */
    public struct Message: Codable, Equatable {

        /// id: unique object identifier (faked - server doesn't provide this yet)
        public let id = UUID()
        /// user: Username of the profile that created the message
        public let user: String
        /// subject: Breif explanation and introduction to the following missive
        public let subject: String
        /// message: The main event and body of the message
        public let message: String

        /// client created Messages, use to create a message object before posting
        public init(user: String, subject: String, message: String) {
            self.user = user
            self.subject = subject
            self.message = message
        }

        /// deserialize
        init(user: String, json: JSON) {
            self.user = user
            self.subject = json["subject"].stringValue
            self.message = json["message"].stringValue
        }

        /// serialize
        func toJSON() -> JSON {
            let json: JSON = [
                "user": user,
                "subject": subject,
                "message": message,
            ]
            return json
        }

        /// merge key/value pair before POST operation to REST api
        static var addMessageOperation: JSON {
            [
                "operation": "add_message"
            ]
        }
    }

}
