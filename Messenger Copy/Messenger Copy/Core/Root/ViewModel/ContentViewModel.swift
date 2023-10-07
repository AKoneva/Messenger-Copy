//
//  ContentViewModel.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/07.
//

import Foundation
import Firebase
import Combine

class ContentViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    
    private var cancelable = Set<AnyCancellable>()

    init() {
        setUpSubscribers()
    }
    
    private func setUpSubscribers() {
        AuthService.shared.$userSession.sink { [weak self] userSessionFromAuthSession in
            self?.userSession = userSessionFromAuthSession
        }.store(in: &cancelable)
    }
}
