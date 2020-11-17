import Foundation

extension MessageService {

    /**
     All error cases for `MessageService` are represented here
     */
    public enum ServiceError: Error, Equatable {
        /// invalidStatusCode: message service API returned an unexpected status code for the given call
        case invalidStatusCode
        /// noDataReturned: message service API did not return data with the call response
        case noDataReturned
        /// generalError: error thrown from internal code, exposes underlying `Error`
        case generalError(Error)

        /// basic comparison for testing
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
