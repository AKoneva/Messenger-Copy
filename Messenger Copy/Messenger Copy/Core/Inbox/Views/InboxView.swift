//
//  InboxView.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/06.
//

import SwiftUI

struct InboxView: View {
    @State private var showNewMessageView: Bool = false
    @StateObject var viewModel = InboxViewModel()
    @State private var selectedUser: User?
    @State private var showChat = false
    
    var body: some View {
        NavigationStack {
            List {
                ActiveNowView()
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                
                ForEach(viewModel.recentMessages) { message in
                    InboxRowView(message: message)
                        .onTapGesture {
                            selectedUser = message.user
                            showChat = true
                        }
                }
                .swipeActions {
                    Button {
                        print("Delete")
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
            .listStyle(.plain)
            .navigationDestination(isPresented: $showChat, destination: {
                if let user = selectedUser {
                    ChatView(user: user)
                }
            })
            .fullScreenCover(isPresented: $showNewMessageView) {
                NewMessageView(selectedUser: $selectedUser)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        NavigationLink {
                            ProfileView(user: viewModel.currentUser ?? User.MOCK_USER)
                        } label: {
                            CircleProfileImageView(profileImageURL: viewModel.currentUser?.profileImageURL ?? "", size: .xSmall)
                        }
                        
                        Text("Chats")
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showNewMessageView.toggle()
                        selectedUser = nil
                    } label: {
                        Image(systemName: "square.and.pencil.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundStyle(.black, Color(.systemGray5))
                    }
                }
            }
        }
    }
}

#Preview {
    InboxView()
}
