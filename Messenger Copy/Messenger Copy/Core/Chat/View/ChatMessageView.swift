//
//  ChatMessage.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/07.
//

import SwiftUI

struct ChatMessageView: View {
    let isFromCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isFromCurrentUser {
                Spacer()
                
                Text("This is text message for now long message lets see what will happend with view")
                    .font(.subheadline)
                    .padding(12)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(ChatBubbleView(isFromCurrentUser: isFromCurrentUser))
                    .frame(width: UIScreen.main.bounds.width / 1.5, alignment: .trailing)
            } else {
                HStack(alignment: .bottom, spacing: 8) {
                    HStack {
                        CircleProfileImageView(user: User.MOCK_USER, size: .xxSmall)
                        
                        Text("This is text message for now.")
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

#Preview {
    ChatMessageView(isFromCurrentUser: false)
}
