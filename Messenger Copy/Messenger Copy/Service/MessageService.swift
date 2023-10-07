//
//  MessageService.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/07.
//

import Foundation
import Firebase

class MessageService {
   static let messagesCollections = Firestore.firestore().collection("messages")
    
    static func sendMessage(_ messageText: String, toUser user: User) {
        guard let currentId = Auth.auth().currentUser?.uid else { return }
        let chatParthnerId = user.id
        
        let currentUserRef = messagesCollections.document(currentId).collection(chatParthnerId).document()
        let chatPartherRef = messagesCollections.document(chatParthnerId).collection(currentId)
        
        let messageId = currentUserRef.documentID
        
        let message = Message(
            messageId: messageId,
            fromId: currentId,
            toId: chatParthnerId,
            message: messageText,
            timeStamp: Timestamp(),
            isRead: false
        )
        
        guard let messageData = try? Firestore.Encoder().encode(message) else { return }
        
        currentUserRef.setData(messageData)
        chatPartherRef.document(messageId).setData(messageData)
    }
}
