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
        
        uploadProfilePhoto(imageData: imageData) { imageUrlString in
            self.user.profileImageURL = imageUrlString
            UserService.updateUser(self.user)
        }
    }
    
    func uploadProfilePhoto(imageData: Data, completion: @escaping (String) -> Void) {
        let storageRef = Storage.storage().reference()
        let profilePhotoRef = storageRef.child("profile_photos/\(user.id).jpg") // User-specific path
        
        profilePhotoRef.putData(imageData, metadata: nil) { (metadata, error) in
            if error != nil {
                print("Could`nt upload photo")
                return
            }
            
            // Successfully uploaded. Generate and return the download URL.
            profilePhotoRef.downloadURL { (url, error) in
                if let url = url {
                    completion(url.absoluteString)
                } else if error != nil {
                    print("Could`nt generale url of photo")
                    return
                }
            }
        }
    }
}
