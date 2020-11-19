import Foundation
import Combine
import MessageService

extension Notification.Name {
    static let MessageDidPost = NSNotification.Name("MessageDidPost")
}

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

            DispatchQueue.main.async {
                self.isPosting = false

                switch result {
                case .success:
                    self.reset()
                    NotificationCenter.default.post(name: .MessageDidPost, object: self, userInfo: nil)

                case .failure:
                    self.hasError = true

                }
            }
        }
    }

}
