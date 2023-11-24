//
//  ProfileView.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/06.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    @State var isImagePickerPresented = false
    
    init(user: User) {
        self._viewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }
    
    var body: some View {
        VStack {
            VStack {
                if let profileImage = viewModel.image {
                    profileImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .onTapGesture {
                            isImagePickerPresented.toggle()
                        }
                } else {
                    ZStack(alignment: .bottomTrailing) {
                        CircleProfileImageView(profileImageURL: viewModel.user.profileImageURL , size: .xLarge)
                        Circle()
                            .fill(.green)
                            .frame(width: 30, height: 30)
                            .overlay {
                                Image(systemName: "photo.fill.on.rectangle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .tint(.white)
                                    .frame(width: 16, height: 16)
                            }
                    }
                    .onTapGesture {
                        isImagePickerPresented.toggle()
                    }
                }
                
                Text(viewModel.user.fullName)
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            
            List {
                Section {
                    ForEach(SettingsViewModel.allCases, id: \.self) { option in
                        HStack {
                            Image(systemName: option.imageName)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(option.imageBackgroundColor)
                            
                            Text(option.title)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                    }
                }
                
                Section {
                    Button("Log out") {
                        AuthService.shared.signOut()
                    }
                    
                    Button("Delete account") {
                        
                    }
                }
                .foregroundColor(.red)
            }
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $viewModel.selectedItem)
        }
//        .onAppear {
//            OnlineService.shared.observeUserPresence()
//        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ProfileView(user: User.MOCK_USER)
}
