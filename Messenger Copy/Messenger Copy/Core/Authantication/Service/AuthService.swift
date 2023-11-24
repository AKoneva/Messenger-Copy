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
    @Published var error: String? = nil

    static let shared = AuthService()

    private init() {
        self.userSession = Auth.auth().currentUser
        loadUserData()
    }

    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            UserService.shared.setUserOnlineStatus(uid: result.user.uid, isOnline: true)
            loadUserData()
        } catch {
            let err = error as NSError
            handleError(error: err)
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
                    profileImageURL: user.photoURL?.absoluteString ?? "",
                    isOnline: true
                )

                UserService.updateUser(userModel)
                self.userSession = result.user
                loadUserData()
            }
        }
    }

    func resetPassword(with email: String) async throws {
        do {
            try await  Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            handleError(error: error)
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
                profilePhoto: profilePhoto,
                isOnline: true
            )
            loadUserData()
        } catch {
            handleError(error: error)
        }
    }


    func signOut() {
        do {
            guard let user = Auth.auth().currentUser else { return }
            UserService.shared.setUserOnlineStatus(uid: user.uid, isOnline: false)
            try Auth.auth().signOut()
            self.userSession = nil
            UserService.shared.currentUser = nil
        } catch {
            handleError(error: error)
        }
    }

    private func uploadUserData(
        uid: String? = nil,
        email: String,
        fullName: String,
        id: String,
        profilePhoto: URL? = nil,
        isOnline: Bool
    ) async throws {
        let user = User(
            uid: uid,
            fullName: fullName,
            email: email,
            profileImageURL: profilePhoto?.absoluteString ?? "",
            isOnline: isOnline
        )
        guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }

        try await Firestore.firestore().collection("users").document(id).setData(encodedUser)
    }

    private func loadUserData() {
        Task { try await UserService.shared.fetchCurrentUser() }
    }

    private func handleError(error: Error) {
        let err = error as NSError
        guard  let authError = AuthErrorCode.Code(rawValue: err.code) else { return }
            switch authError {
                case .accountExistsWithDifferentCredential:
                    self.error = "Account already exist with different credetial"
                case .credentialAlreadyInUse:
                    self.error = "Credential are already in use"
                case .unverifiedEmail:
                    self.error = "An email link was sent to your account, please verify it before loggin in"
                case .userDisabled:
                    self.error = "User is currently disabled"
                case .userNotFound:
                    self.error = "Canno't find the user, try with different credential"
                case .weakPassword:
                    self.error = "Password is too weak"
                case .networkError:
                    self.error = "Error in network connection"
                case .wrongPassword:
                    self.error = "Password is wrong"
                case .invalidEmail:
                    self.error = "Email is not valid"
                default:
                    self.error = error.localizedDescription
        }
    }
}
