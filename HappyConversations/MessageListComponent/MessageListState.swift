import Foundation
import Combine
import MessageService

final class MessageListState: ObservableObject {

    /// subscribe for updates to know when messages are loaded
    @Published private(set) var dataState: DataState = .loading

    /// list of messages loaded from the API
    var messages: [MessageService.Message] {
        get {
            messageContainer?.messages ?? []
        }
    }

    /// if set, queries the API for a single users messages only
    let scopedUser: String?

    init(scopedUser: String? = nil) {
        self.scopedUser = scopedUser
        loadData()
    }

    init(messageContainer: MessageContainer) {
        self.scopedUser = nil
        self.messageContainer = messageContainer
        self.dataState = messageContainer.messages.count == 0 ? .empty : .successful
    }

    //MARK: - Data Query and Response

    private var messageContainer: MessageContainer?
    private var dataTask: URLSessionDataTask?

    private func loadData() {
        dataState = .loading
        messageContainer = nil

        dataTask = MessageService().fetch { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.messageContainer = response
                    self.dataState = response.messages.count == 0 ? .empty : .successful

                case .failure(let error):
                    self.dataState = .error(error)

                }
            }
        }
    }

    // TODO: pull to refresh hook
}

// Allow for other ways to contain messages besides MessageService response
protocol MessageContainer {
    var messages: [MessageService.Message] { get }
}

extension MessageService.MessageResponseData : MessageContainer {}


#if DEBUG

struct FakeMessages : MessageContainer {
    let messages: [MessageService.Message]

    init(count: Int) {
        var messages = [MessageService.Message]()
        for _ in 0..<count {
            messages.append( MessageService.Message.fake() )
        }
        self.messages = messages
    }
}

extension MessageListState {
    static func fake(count: Int) -> MessageListState {
        MessageListState.init(messageContainer: FakeMessages(count: count))
    }
}

#endif

// needed for SwiftUI listing UI
extension MessageService.Message: Identifiable {
}
