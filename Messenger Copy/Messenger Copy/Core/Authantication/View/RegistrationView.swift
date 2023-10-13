//
//  RegistrationView.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/06.
//

import SwiftUI

struct RegistrationView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = RegistrationViewModel()
    @ObservedObject var authService = AuthService.shared
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Image("Messenger")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .shadow(radius: 5)
                
                VStack {
                    TextField("Enter your email", text: $viewModel.email)
                        .font(.subheadline)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal, 24)
                    
                    TextField("Enter your full name", text: $viewModel.fullName)
                        .font(.subheadline)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal, 24)
                    
                    SecureField("Enter your password", text: $viewModel.password)
                        .font(.subheadline)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal, 24)
                    
                    if let error = authService.error {
                        Text(error)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.vertical,5)
                            .padding(.horizontal)
                    }
                }
                
                Button {
                    Task { try await viewModel.createUser() }
                } label: {
                    Text("Sing Up")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(width: 360, height: 44)
                        .background(Color(.systemBlue))
                        .cornerRadius(10)
                }
                .padding(.vertical)
                
                Spacer()
                Divider()
                
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Text("Already have account?")
                        Text("Sing In")
                            .fontWeight(.semibold)
                    }
                    .font(.footnote)
                }
                .padding(.vertical)
            }
        }
    }
}

#Preview {
    RegistrationView()
}
