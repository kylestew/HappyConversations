import SwiftUI

struct AppView: View {
    @EnvironmentObject var appState: AppState
    @State var authIsShowing = false

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
            }
            .navigationBarTitle(Text("Messages"))
            .navigationBarItems(trailing: profileButton)
            .sheet(isPresented: $authIsShowing) {
                AuthView()
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
