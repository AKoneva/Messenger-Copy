//
//  InboxRowView.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/06.
//

import SwiftUI
import FirebaseFirestore

struct InboxRowView: View {
    let message: Message
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            CircleProfileImageView(profileImageURL: message.user?.profileImageURL ?? "", size: .medium)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(message.user?.fullName ?? "")
                    .font(.subheadline)
                    .fontWeight(.semibold)
    
                
                Text(message.messageText)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .lineLimit(2)
            }
            
            HStack {
                Spacer()
                Text(message.timestampString)
                Image(systemName: "chevron.right")
            }
            .font(.footnote)
            .foregroundStyle(.gray)
        }
        .frame(height: 72)
    }
}

#Preview {
    InboxRowView(message: Message(messageId: UUID().uuidString,
                                  fromId: UUID().uuidString,
                                  toId: UUID().uuidString,
                                  messageText: "Test message",
                                  timeStamp: Timestamp(),
                                  isRead: false,
                                  user: nil)
    )
}
