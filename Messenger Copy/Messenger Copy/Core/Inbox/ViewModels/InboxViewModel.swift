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

    @MainActor
    private func loadInitialMessages(from changes: [DocumentChange]) {
        for change in changes {
            switch change.type {
                case .added, .modified:
                    if let message = try? change.document.data(as: Message.self) {
                        UserService.fetchUser(withUid: message.chatPartherID) { user in
                            var settedUserMessage = message
                            settedUserMessage.user = user

                            if let index = self.recentMessages.firstIndex(where: { $0.chatPartherID == settedUserMessage.user?.id }) {
                                self.recentMessages[index] = settedUserMessage
                            } else {
                                self.recentMessages.append(settedUserMessage)
                            }
                        }
                    }
                case .removed:
                    if let message = try? change.document.data(as: Message.self) {
                        recentMessages.removeAll { $0.chatPartherID == message.chatPartherID }
                    }
            }
        }

        recentMessages.sort(by: { $0.timeStamp > $1.timeStamp })
    }


    func deleteChat(with user: User?) {
        guard let user = user else { return }

        let chatService = ChatService(chatParther: user)

        chatService.deleteChat()
    }
}
