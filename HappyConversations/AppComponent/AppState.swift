import Foundation

final class AppState: ObservableObject {

    /// user authorization state, not logged in if nil
    @Published private(set) var auth: UserAuth?

    init() {
    }

    func login(auth: UserAuth) {
        self.auth = auth
    }

    func logout() {
        auth = nil
    }

}
