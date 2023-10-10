//
//  UserService.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/07.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage

class UserService {
    @Published var currentUser: User?
    
    static let shared = UserService()

    @MainActor
    func fetchCurrentUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let userDocRef = FirestoreConstants.UserCollection.document(uid)

        userDocRef.addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("# Error fetching current user document: \(error)")
                return
            }

            guard let snapshot = snapshot else {
                print("# No snapshot data available")
                return
            }

            if snapshot.exists {
                do {
                    let user = try snapshot.data(as: User.self)
                    self.currentUser = user
                    print("User updated: \(user)")
                } catch {
                    print("# Error decoding user data: \(error)")
                }
            } else {
                print("# User document doesn't exist")
            }
        }
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
       FirestoreConstants.UserCollection.document(withUid).getDocument { snapshot, error in
           if error != nil {
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
    
    static func updateUser(_ user: User) {
        let userRef = FirestoreConstants.UserCollection.document(user.id)
        let updatedUserData: [String: Any] = [
            "email": user.email,
            "fullName": user.fullName,
            "profileImageURL": user.profileImageURL
        ]
        
        userRef.setData(updatedUserData, merge: true) { error in
            if let error = error {
                print("Error updating user: \(error.localizedDescription)")
            } else {
                print("User updated successfully")
            }
        }
    }
    
    static func uploadProfilePhoto(user: User, imageData: Data, completion: @escaping (String) -> Void) {
        let storageRef = Storage.storage().reference()
        let profilePhotoRef = storageRef.child("profile_photos/\(user.id).jpg")
        
        profilePhotoRef.putData(imageData, metadata: nil) { (metadata, error) in
            if error != nil {
                print("Could`nt upload photo")
                return
            }
            
            // Successfully uploaded. Generate and return the download URL.
            profilePhotoRef.downloadURL { (url, error) in
                if let url = url {
                    completion(url.absoluteString)
                } else if error != nil {
                    print("Could`nt generale url of photo")
                    return
                }
            }
        }
    }
}
