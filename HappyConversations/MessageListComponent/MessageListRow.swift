import SwiftUI
import MessageService

struct MessageListRow: View {
    var message: MessageService.Message

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("avatar")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .padding(.trailing, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)

                VStack(alignment: .leading, spacing: 4.0) {
                    Text(message.subject)
                        .font(.subheadline)
                        .bold()
                    NavigationLink(
                        destination: MessageListView(state: MessageListState(scopedUser: message.user))
                    ) {
                        Text(message.user)
                            .font(.subheadline)
                    }
                }
                Spacer()
            }.frame(height: 50)
            Text(message.message)
                .font(.callout)
        }.padding()
    }
}

struct MessageListRow_Previews: PreviewProvider {
    static var previews: some View {
        return List {
            MessageListRow(message: MessageService.Message.fake())
            MessageListRow(message: MessageService.Message.fake())
        }
    }
}
