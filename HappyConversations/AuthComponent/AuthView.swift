import SwiftUI

struct AuthView: View {

    @ObservedObject var state: AuthState
    @Binding var showModal: Bool

    var body: some View {
        VStack(alignment: .center) {
            Text("Welcome")
                .font(.largeTitle)
            VStack(alignment: .leading, spacing: 11.0) {
                Text("Select a username")
                    .font(.headline)
                TextField("Username", text: $state.username)
            }
            .padding(20)
            .border(Color.black)
            .padding(60)

            Button("Login".uppercased()) {
                self.state.login()
                self.showModal = false
            }
            .disabled(state.username.isEmpty)
            .font(.title)
            .foregroundColor(Color("Mint"))
        }
        .padding()
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        return AuthView(state: AuthState(appState: AppState()),
                        showModal: .constant(true))
                                      
    }
}
