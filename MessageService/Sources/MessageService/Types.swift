import Foundation

extension MessageService {


    /**
     TODO: describe error cases
     */
    public enum ServiceError: Error, Equatable {
        case invalidStatusCode
        case generalError(Error)

        public static func == (lhs: MessageService.ServiceError, rhs: MessageService.ServiceError) -> Bool {
            switch (lhs, rhs) {
            case (.invalidStatusCode, .invalidStatusCode):
                return true
            case (.generalError(let errA), .generalError(let errB)):
                return (errA as NSError) == (errB as NSError)
            default:
                return false
            }
        }
    }

    /**
     TODO: document these types
     */
    public struct MessagesResult: Codable {
        let statusCode: Int
    }

    public struct StatusOnlyResult: Codable {
        let statusCode: Int
    }

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
