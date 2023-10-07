//
//  ChatViewModel.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/07.
//

import Foundation

class ChatViewModel: ObservableObject {
    @Published var messageText = ""
    var user: User
    
    init(user: User) {
        self.user = user
    }
    
    func sendMessage() {
        MessageService.sendMessage(messageText, toUser: user)
    }
}
