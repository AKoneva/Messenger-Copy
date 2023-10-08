//
//  ChatService.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/08.
//

import Foundation
import Firebase

struct ChatService {
    let chatParther: User
    
     func sendMessage(_ messageText: String) {
        guard let currentId = Auth.auth().currentUser?.uid else { return }
        let chatParthnerId = chatParther.id
        
         let currentUserRef = FirestoreConstants.MessagesCollection.document(currentId).collection(chatParthnerId).document()
        let chatPartherRef = FirestoreConstants.MessagesCollection.document(chatParthnerId).collection(currentId)
        
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
    
     func observeMessages(complition: @escaping([Message]) -> Void) {
        guard let currentId = Auth.auth().currentUser?.uid else { return }
        
         let query = FirestoreConstants.MessagesCollection.document(currentId).collection(chatParther.id)
        
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
                messages[index].user = self.chatParther
            }
            
            complition(messages)
        }
    }
}

