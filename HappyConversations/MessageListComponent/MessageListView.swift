import SwiftUI
import MessageService

struct MessageListView: View {
    @ObservedObject var state: MessageListState

    var body: some View {
        switch state.dataState {
        case .loading:
            HStack {
                ProgressView()
                Text("Loading...")
            }

        case .empty:
            Text("Empty")

        case .error(let error):
            Text("Error \(error.localizedDescription)")

        case .successful:
            List {
                ForEach(state.messages) { message in
                    MessageListCell(message: message)
                }
            }

        }
    }
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        return MessageListView(state: MessageListState())
    }
}


/*
// TEMP: TODO: refactor into testing path
DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
    guard let self = self else { return }

    let testMessages = [
        MessageService.Message(user: "billy",
                               subject: "Hello World",
                               message: "This is a rather long message"),
        MessageService.Message(user: "a really long username",
                               subject: "A really long subject line",
                               message: "This is a rather long message that continues and never goes on. ")
    ]

    self.messages = testMessages
    self.isLoading = false
}
*/
