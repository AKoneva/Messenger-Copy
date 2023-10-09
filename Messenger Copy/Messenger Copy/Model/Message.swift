//
//  Message.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/07.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Message: Identifiable, Codable, Hashable {
    @DocumentID var messageId: String?
    let fromId: String
    let toId: String
    let messageText: String
    let timeStamp: Timestamp
    let isRead: Bool
    
    var user: User?
    
    var id: String {
        return messageId ?? UUID().uuidString
    }
    
    var chatPartherID: String {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
    
    var isFromCurrentUser: Bool {
        return fromId == Auth.auth().currentUser?.uid 
    }
    
    var timestampString: String {
        timeStamp.dateValue().timestampString()
    }
}
