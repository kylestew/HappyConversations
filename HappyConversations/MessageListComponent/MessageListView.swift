import SwiftUI
import MessageService

struct MessageListView: View {
    @ObservedObject var state: MessageListState

    var body: some View {
        switch state.dataState {
        case .loading:
            HStack {
                ProgressView()
                    .padding(.trailing, 10)
                Text("Loading...")
                    .font(.headline)
            }

        case .empty:
            Text("No Messages")
                .font(.headline)

        case .error(let error):
            Text("Error \(error.localizedDescription)")
                .font(.headline)

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
        NavigationView {
            MessageListView(state: MessageListState.fake(count: 3))
        }
    }
}
