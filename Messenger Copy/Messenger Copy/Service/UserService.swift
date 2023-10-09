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
        
        let snapshot = try await FirestoreConstants.UserCollection.document(uid).getDocument()
        let user = try snapshot.data(as: User.self)
        currentUser = user
    }
    
    @MainActor
    static func fetchAllUser(limit: Int? = nil) async throws  -> [User] {
        let query = FirestoreConstants.UserCollection
        if let limit { query.limit(to: limit) }
        let snapshot = try await query.getDocuments()
        
        return try snapshot.documents.compactMap({ try $0.data(as: User.self) })
    }
    
    @MainActor
    static func fetchUser(withUid: String, complition: @escaping(User) -> Void) {
        let snapshot = FirestoreConstants.UserCollection.document(withUid).getDocument { snapshot, error in
            if let error = error {
                print("Error to fetch user with id: \(withUid)")
                return
            }
            
            guard let user = try? snapshot?.data(as: User.self) else {
                print("Error decode user with  id: \(withUid)")
                return
            }
            
            complition(user)
        }
    }
}
