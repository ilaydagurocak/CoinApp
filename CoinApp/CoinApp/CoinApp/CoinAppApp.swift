import SwiftUI
import FirebaseCore

@main
struct CoinAppApp: App {
    
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var coinViewModel = CoinViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(coinViewModel)
        }
    }
}
