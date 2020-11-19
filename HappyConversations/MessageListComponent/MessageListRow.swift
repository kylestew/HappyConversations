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
                    .frame(width: 50, height: 50)

                VStack(alignment: .leading, spacing: 4.0) {
                    Text(message.subject)
                        .font(.title)
                        .bold()
                    Text(message.user)
                }.padding()
                Spacer()
            }
            Text(message.message)
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
