//
//  NewMessageViewModel.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/07.
//

import Foundation
import Combine
import Firebase

class NewMessageViewModel: ObservableObject {
    @Published var users = [User]()
    
    
    init() {
        Task { try await fetchUsers() }
    }

    func fetchUsers() async throws  {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        var users = try await UserService.fetchAllUser()
        self.users = users.filter({ $0.uid != currentUid})
    }
}
