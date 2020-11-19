import SwiftUI

struct AuthView: View {

    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack {

            }
        }
        .padding()
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        return AuthView()
            .environmentObject(AppState())
            .previewLayout(.fixed(width: 300, height: 120))
    }
}
