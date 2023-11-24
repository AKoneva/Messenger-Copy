//
//  ChatView.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/07.
//

import SwiftUI

struct ChatView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: ChatViewModel
    let user: User
    
    init(user: User) {
        self.user = user
        self._viewModel = StateObject(wrappedValue: ChatViewModel(user: user))
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ZStack(alignment: .bottomTrailing) {
                        CircleProfileImageView(profileImageURL: user.profileImageURL, size: .xLarge)
                        if user.isOnline {
                            Circle()
                                .fill(colorScheme == .dark ? .black : .white)
                                .frame(width: 26, height: 26)
                                .overlay {
                                    Circle()
                                        .fill(.green)
                                        .frame(width: 20, height: 20)
                                }
                        }
                    }
                    
                    VStack(spacing: 4) {
                        Text(user.fullName)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("Messenger")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    }
                }
                .padding(.bottom)
                
                LazyVStack {
                    ForEach(viewModel.messages) { message in
                        ChatMessageView(message: message)
                    }
                }
            }
            
            ZStack(alignment: .trailing) {
                TextField("Message...", text: $viewModel.messageText, axis: .vertical)
                    .padding(12)
                    .padding(.trailing, 48)
                    .background(
                        colorScheme == .dark ? Color(.systemGray3) : Color(.systemGroupedBackground)
                        )
                    .clipShape(Capsule())
                    .font(.subheadline)
                
                Button {
                    viewModel.sendMessage()
                    viewModel.messageText = ""
                } label: {
                    Text("Send")
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle(user.fullName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ChatView(user: User.MOCK_USER)
}
