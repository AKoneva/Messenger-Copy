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
    @Published var isLoading = false
    @Published var searchText = "" {
        didSet {
            applySearchFilter()
        }
    }

    var fetchedUsers = [User]()

    @MainActor
    func fetchUsers() {
        isLoading = true

        Task {
            do {
                guard let currentUid = Auth.auth().currentUser?.uid else { return }

                users = try await UserService.fetchAllUser().filter({ $0.uid != currentUid })
                fetchedUsers = users
                isLoading = false
            } catch {
                print(error.localizedDescription)
                isLoading = false
            }
        }
    }

    private func applySearchFilter() {
        if searchText.isEmpty {
            users = fetchedUsers
        } else {
            users = fetchedUsers.filter { user in
                let username = user.fullName.lowercased()
                return username.contains(searchText.lowercased())
            }
        }
    }
}
