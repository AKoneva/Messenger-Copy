//
//  InboxViewModel.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/07.
//

import Foundation
import Firebase
import Combine

@MainActor
class InboxViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var recentMessages = [Message]()
    
    private var cancelable = Set<AnyCancellable>()
    
    let service = InboxService()
    
    init() {
        setUpSubscribers()
        service.observeRecentMessege()
    }
    
    private func setUpSubscribers() {
        UserService.shared.$currentUser.sink { [weak self] userFromUserService in
            self?.currentUser = userFromUserService
        }.store(in: &cancelable)
        
        service.$documentChanges.sink { [weak self] changes in
            self?.loadInitialMessages(from: changes)
        }.store(in: &cancelable)
    }
    
    private func loadInitialMessages(from changes: [DocumentChange]) {
        var messages = changes.compactMap({ try? $0.document.data(as: Message.self) })
        
        for message in messages {
            UserService.fetchUser(withUid: message.chatPartherID) { user in
                var settedUserMessage = message
                settedUserMessage.user = user
                
                if let index = self.recentMessages.firstIndex(where: { $0.chatPartherID == settedUserMessage.user?.id }) {
                    self.recentMessages[index] = settedUserMessage
                } else {
                    self.recentMessages.append(settedUserMessage)
                }
                
                self.recentMessages.sort(by: { $0.timeStamp > $1.timeStamp })
            }
        }
    }
}
