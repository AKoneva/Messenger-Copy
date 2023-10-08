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
            messageText: messageText,
            timeStamp: Timestamp(),
            isRead: false
        )
        
        guard let messageData = try? Firestore.Encoder().encode(message) else { return }
        
        currentUserRef.setData(messageData)
        chatPartherRef.document(messageId).setData(messageData)
    }
    
    static func observeMessages(chatParther: User, complition: @escaping([Message]) -> Void) {
        guard let currentId = Auth.auth().currentUser?.uid else { return }
        let chatPartherId = chatParther.id
        
        let query = messagesCollections.document(currentId).collection(chatPartherId)
        
        let listener = query.addSnapshotListener { (querySnapshot, error) in
            guard let changes = querySnapshot?.documentChanges.filter({ $0.type == .added }) else {
                print("Error filer documents")
                return
            }
            
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            
            var messages = changes.compactMap({ try? $0.document.data(as: Message.self) })
            for (index, message) in messages.enumerated() where message.fromId != currentId {
                messages[index].user = chatParther
            }
            
            complition(messages)
        }
    }
}
