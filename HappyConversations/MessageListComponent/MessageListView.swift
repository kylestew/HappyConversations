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
                    MessageListRow(message: message)
                }
            }

        }
    }
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        return MessageListView(state: MessageListState.fake(count: 3))
    }
}
