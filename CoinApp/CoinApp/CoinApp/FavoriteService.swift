import Foundation
import FirebaseAuth
import FirebaseFirestore

final class FavoriteService {
    
    private let db = Firestore.firestore()
    
    func addFavorite(coinId: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in."])
        }
        
        try await db.collection("users")
            .document(uid)
            .collection("favorites")
            .document(coinId)
            .setData([
                "coinId": coinId,
                "createdAt": Timestamp(date: Date())
            ])
    }
    
    func removeFavorite(coinId: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in."])
        }
        
        try await db.collection("users")
            .document(uid)
            .collection("favorites")
            .document(coinId)
            .delete()
    }
    
    func fetchFavorites() async throws -> [String] {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in."])
        }
        
        let snapshot = try await db.collection("users")
            .document(uid)
            .collection("favorites")
            .getDocuments()
        
        return snapshot.documents.map { $0.documentID }
    }
}
