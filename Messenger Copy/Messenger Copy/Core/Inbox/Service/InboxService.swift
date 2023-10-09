//
//  InboxService.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/08.
//

import Foundation
import Firebase

class InboxService {
    @Published var documentChanges = [DocumentChange]()
    
    func observeRecentMessege() {
        guard let currentId = Auth.auth().currentUser?.uid else { return }
        
        let query = FirestoreConstants
            .MessagesCollection
            .document(currentId)
            .collection("mostRecentMessages")
        
        query.addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("# Error fetching recent message documents: \(error)")
                return
            }
            
            guard let changes = snapshot?.documentChanges.filter({
                $0.type == .added || $0.type == .modified
            }) else {
                print("# Error filer documents of recent message")
                return
            }
            
            self.documentChanges = changes
        }
    }
}
