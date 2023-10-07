//
//  ChatView.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/07.
//

import SwiftUI

struct ChatView: View {
    @State private var messageText = ""
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    CircleProfileImageView(user: User.MOCK_USER, size: .xLarge)
                    
                    VStack(spacing: 4) {
                        Text(User.MOCK_USER.fullName)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("Messenger")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    }
                }
                .padding(.bottom)
                
                ForEach(0 ... 15, id: \.self) { message in
                    ChatMessageView(isFromCurrentUser: Bool.random())
                }
            }
            
            ZStack(alignment: .trailing) {
                TextField("Message...", text: $messageText, axis: .vertical)
                    .padding(12)
                    .padding(.trailing, 48)
                    .background(Color(.systemGroupedBackground))
                    .clipShape(Capsule())
                    .font(.subheadline)
                
                Button {
                    
                } label: {
                    Text("Send")
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
}

#Preview {
    ChatView()
}
