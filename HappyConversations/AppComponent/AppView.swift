import SwiftUI

struct AppView: View {
    @EnvironmentObject var appState: AppState
    @State private var authIsShowing = false
    @State private var logoutIsShowing = false

    var profileButton: some View {
        Button(action: {
            if appState.auth != nil {
                self.logoutIsShowing.toggle()
            } else {
                self.authIsShowing.toggle()
            }
        }) {
            if let auth = appState.auth {
                Text(auth.user)
            } else {
                Text("Login")
            }
        }
        .foregroundColor(Color("Mint"))
    }

    var logoutActionSheet: ActionSheet {
        ActionSheet(title: Text("You are logged in"),
                    message: Text("Do you want to logout?"), buttons: [
                        .destructive(Text("Logout")) {
                            self.appState.logout()

                        },
                        .cancel()
                    ])
    }

    var signUpCTA: some View {
        Button(action: {
            self.authIsShowing.toggle()
        }) {
            Text("Login to join the conversation")
                .font(.headline)
                .padding(30)
                .foregroundColor(Color("Yellow"))
        }
        .frame(maxWidth: .infinity)
        .background(Color("Green"))
        .border(Color("Blue"), width: 8)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                MessageListView(state: MessageListState())

                if let auth = appState.auth {
                    PostingView(state: PostingState(auth: auth))
                } else {
                    signUpCTA
                        .padding(0)
                }
            }
            .navigationBarItems(trailing: profileButton)
            .actionSheet(isPresented: $logoutIsShowing) {
                logoutActionSheet
            }
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
