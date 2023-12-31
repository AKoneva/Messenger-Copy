//
//  LoginViewModel.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/07.
//

import SwiftUI
import Firebase

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func login() async throws {
        try await AuthService.shared.login(withEmail: email, password: password)
    }
    
    func loginWithGooggle(credentals: AuthCredential) async throws {
        try await AuthService.shared.loginWithGoogle(credential: credentals)
    }
}
