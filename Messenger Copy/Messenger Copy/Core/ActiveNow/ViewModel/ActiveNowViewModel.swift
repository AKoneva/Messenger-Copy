//
//  ActiveNowViewModel.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/09.
//

import Foundation
import Firebase

class ActiveNowViewModel: ObservableObject {
    @Published var users = [User]()
    let cuttentUserId = Auth.auth().currentUser?.uid
    
    init() {
        Task { try await fetchUsers() }
    }
    
    @MainActor
    private func fetchUsers() async throws {
        let users = try await UserService.fetchAllUser(limit: 10)
        self.users = users.filter({ $0.id != cuttentUserId })
    }
}
