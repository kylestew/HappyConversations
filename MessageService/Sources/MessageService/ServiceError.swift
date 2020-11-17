import Foundation

extension MessageService {

    /**
     TODO: describe error cases
     */
    public enum ServiceError: Error, Equatable {
        case invalidStatusCode
        case noDataReturned
        case generalError(Error)

        public static func == (lhs: MessageService.ServiceError, rhs: MessageService.ServiceError) -> Bool {
            switch (lhs, rhs) {
            case (.invalidStatusCode, .invalidStatusCode):
                return true
            case (.noDataReturned, .noDataReturned):
                return true
            case (.generalError(let errA), .generalError(let errB)):
                return (errA as NSError) == (errB as NSError)
            default:
                return false
            }
        }
    }

}
