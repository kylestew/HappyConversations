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

    public struct Message: Codable {
        let user: String
        let subject: String
        let message: String
    }

}
