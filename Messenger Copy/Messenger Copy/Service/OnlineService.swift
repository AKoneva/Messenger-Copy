//
//  OnlineService.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/11/23.
//

import Foundation
import Firebase

class OnlineService {
    static let shared = OnlineService()

    private let db = Database.database().reference()
    private let userPresenceRef = Database.database().reference(withPath: "user-presence")

    func setUserOnline() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let presenceRef = userPresenceRef.child(uid)
        presenceRef.setValue(true)
        presenceRef.onDisconnectRemoveValue()
    }

    func setUserOffline() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let presenceRef = userPresenceRef.child(uid)
        presenceRef.removeValue()
    }

    func observeUserPresence() {
        guard let user = Auth.auth().currentUser else { return }
        let presenceRef = userPresenceRef.child(user.uid)

        // Observe changes to user presence
        presenceRef.observe(.value) { snapshot in
            UserService.shared.currentUser?.isOnline = snapshot.exists()
        }
    }
}

