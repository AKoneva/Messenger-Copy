//
//  NewMessageView.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/06.
//

import SwiftUI

struct NewMessageView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = NewMessageViewModel()
    @Binding var selectedUser: User?

    var body: some View {
        NavigationStack {
            ScrollView {
                TextField("To", text: $viewModel.searchText)
                    .frame(height: 44)
                    .padding(.leading)
                    .background(colorScheme == .dark ? Color(.systemGray3) : Color(.systemGroupedBackground))

                Text("CONTACTS")
                    .font(.footnote)
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()

                VStack {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        ForEach(viewModel.users) { user in
                            VStack {
                                HStack {
                                    CircleProfileImageView(profileImageURL: user.profileImageURL, size: .small)
                                    Text(user.fullName)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                Divider()
                            }
                            .onTapGesture {
                                selectedUser = user
                                dismiss()
                            }
                        }
                    }

                }
            }
            .navigationTitle("New message")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
            }
            .onAppear {
                Task { viewModel.fetchUsers() }
            }
        }
    }
}

#Preview {
    NewMessageView(selectedUser: .constant(User.MOCK_USER))
}
