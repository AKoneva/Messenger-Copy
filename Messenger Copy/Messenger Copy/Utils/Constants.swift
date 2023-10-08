//
//  Constants.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/08.
//

import Foundation
import Firebase

struct FirestoreConstants {
    static let UserCollection = Firestore.firestore().collection("users")
    static let MessagesCollection = Firestore.firestore().collection("messages")
}
