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
            ScrollViewReader { value in
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
                .onAppear {
                    // Scroll to the last message when the view appears
                    scrollToLastMessage(value)
                }
                .onChange(of: viewModel.messages.count) { _ in
                    // Scroll to the last message when the number of messages changes
                    scrollToLastMessage(value)
                }
                .onChange(of: viewModel.messages.last?.messageId) { _ in
                    // Scroll to the last message when the last message changes
                    scrollToLastMessage(value)
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
                    hideKeyboard()
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

    private func scrollToLastMessage(_ value: ScrollViewProxy) {
        withAnimation {
            if let lastMessageId = viewModel.messages.last?.messageId {
                value.scrollTo(lastMessageId, anchor: .bottom)
            }
        }
    }
}

#Preview {
    ChatView(user: User.MOCK_USER)
}
