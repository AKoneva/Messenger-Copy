//
//  UserProfileView.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/09.
//

import SwiftUI

struct UserProfileView: View {
    @State var user: User
    @State var isBlocked = false
    var body: some View {
        VStack {
            Spacer()
            VStack {
                CircleProfileImageView(user: user, size: .xLarge)
                Text(user.fullName)
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(user.email)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
            }
            .padding()
            Spacer()
            
            VStack {
                NavigationLink {
                    ChatView(user: user)
                } label: {
                    HStack {
                        Image(systemName: "message")
                        Text("Show message")
                    }
                }
                .buttonStyle(CustomButtonStyle(
                                backgroundColor: Color.blue,
                                foregroundColor: Color.white,
                                cornerRadius: 10
                            ))
                Button {
                    isBlocked.toggle()
                } label: {
                    if isBlocked {
                        HStack {
                            Image(systemName: "person.fill.checkmark")
                            Text("Unblock \(user.fullName)")
                        }
                    } else {
                        HStack {
                            Image(systemName: "person.fill.xmark")
                            Text("Block \(user.fullName)")
                        }
                    }
                }
                .buttonStyle(CustomButtonStyle(
                    backgroundColor: isBlocked ? .gray : .red,
                                foregroundColor: Color.white,
                                cornerRadius: 10
                            ))
            }
            Spacer()
        }
    }
}

#Preview {
    UserProfileView(user: User.MOCK_USER)
}
