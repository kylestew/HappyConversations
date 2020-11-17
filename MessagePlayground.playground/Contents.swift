import PlaygroundSupport
import MessageService

/// SERVICE URL - follow along here as you run this playground
/// https://abraxvasbh.execute-api.us-east-2.amazonaws.com/proto/messages

let service = MessageService()

// =========================
// Post a message
// =========================
let message = MessageService.Message(user: "billy", subject: "Hello World", message: "Let the conversations begin!")
let task = service.post(message) { result in
    switch result {
    case .success(let response):
        let statusCode = response.statusCode

        // =========================
        // Get all messages
        // =========================
        let task = service.fetch { result in
            switch result {
            case .success(let response):
                let message = response.messages
                let messagesByUser = response.messagesByUser()
                let myMessages = response.messages(for: "billy")

            default: break

                PlaygroundPage.current.finishExecution()
            }
        }
    default: break
    }
}

PlaygroundPage.current.needsIndefiniteExecution = true
