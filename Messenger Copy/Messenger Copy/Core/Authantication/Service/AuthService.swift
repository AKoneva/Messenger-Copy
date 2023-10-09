//
//  AuthService.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/07.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import GoogleSignIn

class AuthService: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    
    static let shared = AuthService()
    
    init() {
        self.userSession = Auth.auth().currentUser
        loadUserData()
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            loadUserData()
        } catch {
            print("Fail to sign in  user with error \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func loginWithGoogle(credential: AuthCredential) async throws {
        do {
            let result = try await Auth.auth().signIn(with: credential)
                if let user = Auth.auth().currentUser {
                    let userModel = User(
                        uid: user.uid,
                        fullName: user.displayName ?? "",
                        email: user.email ?? "",
                        profileImageURL: user.photoURL?.absoluteString ?? ""
                    )
                    
                    UserService.updateUser(userModel)
                    self.userSession = result.user
                    loadUserData()
                }
        }
    }
    
    
    @MainActor
    func createUser(
        uid: String? = nil,
        withEmail email: String,
        password: String,
        fullName: String,
        profilePhoto: URL? = nil
    ) async throws {
        do {
            let results = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = results.user
            try await uploadUserData(
                uid: uid,
                email: email,
                fullName: fullName,
                id: results.user.uid,
                profilePhoto: profilePhoto
            )
            loadUserData()
        } catch {
            print("Fail to create user with error \(error.localizedDescription)")
        }
    }
    
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            UserService.shared.currentUser = nil
        } catch {
            print("Fail to sign out  user with error \(error.localizedDescription)")
        }
    }
    
    private func uploadUserData(
        uid: String? = nil,
        email: String,
        fullName: String,
        id: String,
        profilePhoto: URL? = nil
    ) async throws {
        let user = User(
            uid: uid,
            fullName: fullName,
            email: email,
            profileImageURL: profilePhoto?.absoluteString ?? ""
        )
        guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
        
        try await Firestore.firestore().collection("users").document(id).setData(encodedUser)
    }
    
    private func loadUserData() {
        Task { try await UserService.shared.fetchCurrentUser() }
    }
}
