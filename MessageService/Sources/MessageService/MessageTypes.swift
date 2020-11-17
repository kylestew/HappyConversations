import Foundation

extension MessageService {

    /**
     TODO: document these types
     */
    public struct MessagesResult: Codable {
        let statusCode: Int
    }

    /**
     */
    public struct Message: Codable {
        let user: String
        let subject: String
        let message: String
        let operation: String?

        public init(user: String, subject: String, message: String, operation: String? = nil) {
            self.user = user
            self.subject = subject
            self.message = message
            self.operation = operation
        }

        public func asCreateOp() -> Message {
            return Message.init(user: self.user, subject: self.subject, message: self.message, operation: "add_message")
        }
    }

}
