import SwiftUI

struct PostingView: View {

    @ObservedObject var state: PostingState

    var body: some View {
        VStack {
            if state.isPosting {
                HStack {
                    ProgressView()
                        .padding()
                    Text("Posting...")                
                }.frame(maxWidth: .infinity, minHeight: 108)
            } else {
                HStack(alignment: .top) {
                    TextField("Subject", text: $state.subject)
                    Button("Post") {
                        state.post()
                    }
                    .font(.headline)
                    .foregroundColor(Color("Mint"))
                    .padding([.leading, .trailing], 30)
                    .padding([.top, .bottom], 10)
                    .background(Color("Yellow"))
                    .disabled(state.subject.isEmpty || state.message.isEmpty)
                }
                TextField("Message", text: $state.message)
                    .multilineTextAlignment(.leading)
                    .frame(minHeight: 60)
            }
        }.alert(isPresented: $state.hasError) {
            Alert(title: Text("Uh oh!"), message: Text("Something went wrong"))
        }
        .padding(30)
        .border(Color("Blue"), width: 12)
    }
}

struct PostingView_Previews: PreviewProvider {
    static var previews: some View {
        let auth = UserAuth(user: "demo")
        return PostingView(state: PostingState(auth: auth))
            .previewLayout(.fixed(width: 320, height: 240))
    }
}
