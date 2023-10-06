//
//  ProfileView.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/06.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    var body: some View {
        VStack {
            VStack {
                PhotosPicker(selection: $viewModel.selectedItem) {
                    if let profileImage = viewModel.image {
                        profileImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                        
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)
                    }
                }
                
                Text("Name Surname")
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
                        
                    }
                    Button("Delete account") {
                        
                    }
                }
                .foregroundColor(.red)
            }
        }
    }
}

#Preview {
    ProfileView()
}
