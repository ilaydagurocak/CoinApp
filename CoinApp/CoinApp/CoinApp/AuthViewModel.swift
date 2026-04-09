import Foundation
import FirebaseAuth

@MainActor
final class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var infoMessage = ""
    
    init() {
        self.userSession = Auth.auth().currentUser
    }
    
    func login(email: String, password: String) async {
        errorMessage = ""
        infoMessage = ""
        isLoading = true
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func register(email: String, password: String) async {
        errorMessage = ""
        infoMessage = ""
        isLoading = true
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func sendPasswordReset(email: String) async {
        errorMessage = ""
        infoMessage = ""
        isLoading = true
        
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            infoMessage = "Password reset email gönderildi."
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func signOut() {
        errorMessage = ""
        infoMessage = ""
        
        do {
            try Auth.auth().signOut()
            userSession = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
