//
//  ActiveNowView.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/06.
//

import SwiftUI

struct ActiveNowView: View {
    @StateObject var viewModel = ActiveNowViewModel()
    @State var showUserProfile = false
    @State private var selectedUser: User?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 32) {
                ForEach(viewModel.users) { user in
                    VStack {
                        ZStack(alignment: .bottomTrailing) {
                            CircleProfileImageView(user: user, size: .medium)
                            Circle()
                                .fill(.white)
                                .frame(width: 18, height: 18)
                                .overlay {
                                    Circle()
                                        .fill(.green)
                                        .frame(width: 12, height: 12)
                                }
                        
                        }
                        Text(user.firstName)
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    }
                    .onTapGesture {
                        selectedUser = user
                        showUserProfile = true
                    }
                }
            }
            .padding()
        }
        .frame(height: 120)
        .navigationDestination(isPresented: $showUserProfile, destination: {
            if let user = selectedUser {
                UserProfileView(user: user)
            }
        })
    }
}

#Preview {
    ActiveNowView()
}
