//
//  ProfileViewModel.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/06.
//

import Foundation
import SwiftUI
import PhotosUI
import FirebaseStorage

class ProfileViewModel: ObservableObject {
    @Published var selectedItem: UIImage? {
        didSet {
            Task {
                try await loadImage()
            }
        }
    }
    @Published var user: User
    
    @Published var image: Image?
    
    init(user: User) {
        self.user = user
    }
    
    @MainActor
    func loadImage() async throws {
        guard let item = selectedItem else { return }
        self.image = Image(uiImage: item)
        
        guard let imageData = item.jpegData(compressionQuality: 0.8) else {
            print("Could`nt encode image to data.")
                return
            }
        
        UserService.uploadProfilePhoto(user: self.user, imageData: imageData) { imageUrlString in
            self.user.profileImageURL = imageUrlString
            UserService.updateUser(self.user)
        }
    }
   
}
