//
//  ForgotPasswordViewModel.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/13.
//

import Foundation

class ForgotPasswordViewModel: ObservableObject {
    @Published var email = ""

    func resetPassword() async throws {
         try await AuthService.shared.resetPassword(with: email)
    }
}
