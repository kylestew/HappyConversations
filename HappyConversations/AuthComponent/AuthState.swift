import Foundation

final class AuthState: ObservableObject {

    @Published var username = ""

    let appState: AppState

    init(appState: AppState) {
        self.appState = appState
    }

    func login() {
        appState.login(auth: UserAuth(user: username))
    }

}
