import Foundation
import Combine
import MessageService

final class PostingState: ObservableObject {

    @Published var isPosting = false
    @Published var hasError = false
    @Published var subject = ""
    @Published var message = ""

    // TODO: only enable post button if text is entered

    private let auth: UserAuth

    init(auth: UserAuth) {
        self.auth = auth
    }

    func reset() {
        subject = ""
        message = ""
    }

    private var dataTask: URLSessionDataTask?

    // TRADEOFF: State mutates itself
    // there has to be a cleaner way!!!
    func post() {
        isPosting = true

        let post = MessageService.Message(user: auth.user,
                                          subject: subject,
                                          message: message)
        dataTask = MessageService().post(post) { [weak self] result in
            guard let self = self else { return }

            self.isPosting = false
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.reset()
                    // TODO: post global message to reload messages list

                case .failure:
                    self.hasError = true

                }
            }
        }
    }

}
