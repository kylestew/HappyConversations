import SwiftUI
import MessageService

struct MessageListCell: View {
    var message: MessageService.Message

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                // TODO: placeholder profile image (pull stock photo?)
                Rectangle()
                    .background(Color.red)
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading) {
                    Text(message.subject)
                    Text(message.user)
                }
                Spacer()
            }
            Text(message.message)
        }.padding()
    }
}

struct MessageListCell_Previews: PreviewProvider {
    static var previews: some View {
        let messages = [
            MessageService.Message(user: "billy",
                                   subject: "Hello World",
                                   message: "This is a rather long message"),
            MessageService.Message(user: "a really long username",
                                   subject: "A really long subject line",
                                   message: "This is a rather long message that continues and never goes on. ")
        ]

        return Group {
            MessageListCell(message: messages[0])
            MessageListCell(message: messages[1])
        }.previewLayout(.fixed(width: 300, height: 70))
    }
}
