import SwiftUI

struct PostingView: View {

    @ObservedObject var state: PostingState

    var body: some View {
        VStack {
            if state.isPosting {
                HStack {
                    ProgressView()
                    Text("Posting...")                
                }
            } else {
                HStack {
                    TextField("Subject", text: $state.subject)
                    Button("Post") {
                        state.post()
                    }
                    .disabled(state.subject.isEmpty || state.message.isEmpty)
                }
                TextField("Message", text: $state.message)
            }
        }.alert(isPresented: $state.hasError) {
            Alert(title: Text("Uh oh!"), message: Text("Something went wrong"))
        }
        .border(Color.black)
    }
}

struct PostingView_Previews: PreviewProvider {
    static var previews: some View {
        let auth = UserAuth(user: "demo")
        return PostingView(state: PostingState(auth: auth))
            .previewLayout(.fixed(width: 300, height: 120))
    }
}
