import SwiftUI

struct AppView: View {
    @EnvironmentObject var appState: AppState
    @State private var authIsShowing = false

    var profileButton: some View {
        Button(action: {
            if appState.auth != nil {
                self.appState.logout()
            } else {
                self.authIsShowing.toggle()
            }
        }) {
            if appState.auth != nil {
                Text("Logout")
            } else {
                Text("Login")
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                MessageListView(state: MessageListState())
                if let auth = appState.auth {
                    PostingView(state: PostingState(auth: auth))
                } else {
                    Button(action: {
                        self.authIsShowing.toggle()
                    }) {
                        Text("Login to join the conversation")
                    }
                }
            }
            .navigationBarItems(trailing: profileButton)
            .sheet(isPresented: $authIsShowing) {
                AuthView.init(state: AuthState(appState: appState),
                              showModal: self.$authIsShowing)
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
            .environmentObject(AppState())
    }
}
