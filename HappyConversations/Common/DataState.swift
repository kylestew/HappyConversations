import Foundation

enum DataState {
    case loading
    case successful
    case empty
    case error(Error)
}
