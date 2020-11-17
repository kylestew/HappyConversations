import Foundation
import SwiftyJSON

extension MessageService {

    public struct MessageResponseData {
        public let statusCode: Int
        let body: JSON

        init(statusCode: Int, body: JSON) {
            self.statusCode = statusCode
            self.body = body
        }

        public var messages: [Message] {
            var messages = [Message]()
            for (key, subJson) : (String, JSON) in body {
                let userMessages = subJson.arrayValue.map { Message(user: key, subject: $0["subject"].stringValue, message: $0["message"].stringValue) }
                messages.append(contentsOf: userMessages)
            }
            return messages
        }
    }

    /**
     */
    public struct Message: Codable, Equatable {
        public let user: String
        public let subject: String
        public let message: String
//        public let operation: String?

//        public init(user: String, subject: String, message: String, operation: String? = nil) {
//            self.user = user
//            self.subject = subject
//            self.message = message
////            self.operation = operation
//        }

        // TODO: extend JSON object
//        public func asCreateOp() -> Message {
//            return Message.init(user: self.user, subject: self.subject, message: self.message, operation: "add_message")
//        }
    }

}
