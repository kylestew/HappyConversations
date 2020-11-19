import Foundation

final class AppState: ObservableObject {

    /// user authorization state, not logged in if nil
    @Published private(set) var auth: AuthData?

    init() {
        self.auth = AuthData.init(user: "hello")
    }

    func logout() {
        auth = nil
    }

}
