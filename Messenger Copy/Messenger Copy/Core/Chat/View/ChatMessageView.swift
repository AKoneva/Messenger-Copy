//
//  ChatMessage.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/07.
//

import SwiftUI

struct ChatMessageView: View {
    let message: Message
    
    private var isFromCurrentUser: Bool {
        return message.isFromCurrentUser
    }
    
    var body: some View {
        HStack {
            if isFromCurrentUser {
                Spacer()
                
                Text(message.messageText)
                    .font(.subheadline)
                    .padding(12)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(ChatBubbleView(isFromCurrentUser: isFromCurrentUser))
                    .frame(width: UIScreen.main.bounds.width / 1.5, alignment: .trailing)
            } else {
                HStack(alignment: .bottom, spacing: 8) {
                    HStack {
                        CircleProfileImageView(user: message.user, size: .xxSmall)
                        
                        Text(message.messageText)
                            .font(.subheadline)
                            .padding(12)
                            .background(Color(.systemGray5))
                            .foregroundStyle(.black)
                            .clipShape(ChatBubbleView(isFromCurrentUser: isFromCurrentUser))
                            .frame(width: UIScreen.main.bounds.width / 1.75, alignment: .leading)
                        
                        Spacer()
                    }
                }
            }
        }
        .padding(.horizontal, 8)
    }
}
