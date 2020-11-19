import SwiftUI
import MessageService

struct MessageListView: View {
    @ObservedObject var state: MessageListState

    var navTitle: String {
        if let user = state.scopedUser {
            return user
        }
        return "Messages"
    }

    var body: some View {
        VStack {
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
                .navigationBarTitle(Text(navTitle))

            }
            Spacer()
        }
    }
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MessageListView(state: MessageListState.fake(count: 5))
        }
    }
}
