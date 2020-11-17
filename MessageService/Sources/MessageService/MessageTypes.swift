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

        func toJSON() -> JSON {
            let json: JSON = [
                "user": user,
                "subject": subject,
                "message": message,
            ]
            return json
        }
    }

}
