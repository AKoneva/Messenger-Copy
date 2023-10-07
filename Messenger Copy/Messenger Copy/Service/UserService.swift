//
//  UserService.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/07.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class UserService {
    @Published var currentUser: User?
    
    static let shared = UserService()
    
    @MainActor
    func fetchCurrentUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        let user = try snapshot.data(as: User.self)
        currentUser = user
    }
    
    @MainActor
    static func fetchAllUser() async throws  -> [User] {
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        return try snapshot.documents.compactMap({ try $0.data(as: User.self) })
    }
}
