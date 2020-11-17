import PlaygroundSupport
import MessageService

let service = MessageService()

// post a message
let message = MessageService.Message(user: "me", subject: "Hello World", message: "Let the conversations begin!")
let handle = service.post(message) { result in
    switch result {
    case .success(let response):
        print(response.statusCode)
    default: break
    }

    PlaygroundPage.current.finishExecution()
}


// get all messages
//let bob = service.fetch { result in
//    switch result {
//    case .success(let response):
//        print(response)
//
//    case .failure(let error):
//        assertionFailure()
//    }
//
//}

PlaygroundPage.current.needsIndefiniteExecution = true
