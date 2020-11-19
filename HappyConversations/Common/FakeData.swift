import Foundation
import MessageService

#if DEBUG

extension MessageService.Message {
    static func fake() -> MessageService.Message {
        let user: String
        let subject: String
        let message: String
        let dice = Int.random(in: 0...3)

        switch dice {
        case 1:
            user = "Billy"
            subject = "Message Title"
            message = "The body of the message goes here"

        case 2:
            user = "Sally"
            subject = "I like to ride horses"
            message = "There is a really nice horse ranch outside Escondido that you should really check out!"

        default:
            user = "Lorem"
            subject = "A message from sir ipsum"
            message = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

        }

        return MessageService.Message(user: user,
                               subject: subject,
                               message: message)
    }
}

#endif
