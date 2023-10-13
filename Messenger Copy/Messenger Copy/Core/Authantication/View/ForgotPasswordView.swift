//
//  ForgotPasswordView.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/13.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ForgotPasswordViewModel()
    @ObservedObject var authService = AuthService.shared
    @State var showAlert = false

    var body: some View {
        NavigationStack {
            VStack {
                Image("Messenger")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .shadow(radius: 5)
                    .padding()
                    .padding(.top, 60)

                VStack {
                    TextField("Enter your email", text: $viewModel.email)
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

                    Button {
                        authService.error = nil
                        Task {
                            do {
                                try await viewModel.resetPassword()
                                if  authService.error == nil {
                                    showAlert = true
                                    dismiss()
                                }
                            } catch {
                                authService.error = error.localizedDescription
                            }
                        }

                    } label: {
                        Text("Reset password")
                    }
                    .buttonStyle(CustomButtonStyle(
                        backgroundColor: Color.blue,
                        foregroundColor: Color.white,
                        cornerRadius: 10
                    ))
                    .padding(.vertical)
                }

                Spacer()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Request to reset password has been sent"),
                    message: Text("Check your email for futher instructions."),
                    dismissButton: .default(Text("OK")) {}
                )
            }
        }
    }
}

#Preview {
    ForgotPasswordView()
}
