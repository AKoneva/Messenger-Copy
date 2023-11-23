//
//  InboxRowView.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/06.
//

import SwiftUI
import FirebaseFirestore

struct InboxRowView: View {
    @Environment(\.colorScheme) var colorScheme
    let message: Message
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                CircleProfileImageView(profileImageURL: message.user?.profileImageURL ?? "", size: .medium)
                if message.user?.isOnline ?? false {
                    Circle()
                        .fill(colorScheme == .dark ? .black : .white)
                        .frame(width: 18, height: 18)
                        .overlay {
                            Circle()
                                .fill(.green)
                                .frame(width: 12, height: 12)
                        }
                }
            }

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
            .foregroundStyle(colorScheme == .dark ? .white : .gray)
        }
        .frame(height: 72)
    }
}

#Preview {
    InboxRowView(message: Message.MOCK_MESSAGE)
}
