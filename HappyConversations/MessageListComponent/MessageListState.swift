import Foundation
import Combine
import MessageService

final class MessageListState: ObservableObject {

    /// subscribe for updates to know when messages are loaded
    @Published private(set) var dataState: DataState = .loading

    /// list of messages loaded from the API
    var messages: [MessageService.Message] {
        get {
            responseData?.messages ?? []
        }
    }

    /// if set, queries the API for a single users messages only
    let scopedUser: String?

    init(scopedUser: String? = nil) {
        self.scopedUser = scopedUser
        loadData()
    }

    //MARK: - Data Query and Response

    private var responseData: MessageService.MessageResponseData?
    private var dataTask: URLSessionDataTask?

    private func loadData() {
        self.dataState = .loading
        self.responseData = nil

        dataTask = MessageService().fetch { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.responseData = response
                    self.dataState = response.messages.count == 0 ? .empty : .successful

                case .failure(let error):
                    self.dataState = .error(error)

                }
            }
        }
    }

    // TODO: pull to refresh hook
}

// needed for SwiftUI listing UI
extension MessageService.Message: Identifiable {
}
