//
//  LoginView.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/06.
//

import SwiftUI
import GoogleSignIn
import Firebase

struct LoginView: View {
    @ObservedObject var viewModel = LoginViewModel()
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
                    
                } label: {
                    Text("Forgot password?")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(.top)
                        .padding(.horizontal, 28)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                Button {
                    Task { try await viewModel.login() }
                } label: {
                    Text("Login")
                }
                .buttonStyle(CustomButtonStyle(
                    backgroundColor: Color.blue,
                    foregroundColor: Color.white,
                    cornerRadius: 10
                ))
                .padding(.vertical)
                
                HStack {
                    Rectangle()
                        .frame(width: (UIScreen.main.bounds.width/2) - 40, height: 0.5)
                    Text("OR")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    Rectangle()
                        .frame(width: (UIScreen.main.bounds.width/2) - 40, height: 0.5)
                }
                .foregroundColor(.gray)
                
                Button {
                    signInWithGoogle()
                } label: {
                    HStack {
                        Image("Google")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                        Text("Continue with Google")
                    }
                }
                .buttonStyle(CustomButtonStyle(
                    backgroundColor: Color.white,
                    foregroundColor: Color.black,
                    cornerRadius: 10
                ))
                .padding(.vertical)
                
                
                Spacer()
                Divider()
                
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack {
                        Text("Don`t have account?")
                        Text("Sing Up")
                            .fontWeight(.semibold)
                    }
                    .font(.footnote)
                }
                .padding(.vertical)
                
            }
        }
    }
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: getRootController()) { [self] result, error in
            if let error = error {
                print("# Error signing in with Google: \(error.localizedDescription)")
                AuthService.shared.error = error.localizedDescription
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                print("# Error decoding user or couldn't get idToken")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            Task {
                do {
                    try await viewModel.loginWithGooggle(credentals: credential)
                } catch {
                    print("# Error during login: \(error.localizedDescription)")
                    AuthService.shared.error = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
