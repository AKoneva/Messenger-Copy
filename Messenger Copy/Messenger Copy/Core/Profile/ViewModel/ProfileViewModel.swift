//
//  ProfileViewModel.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/06.
//

import Foundation
import SwiftUI
import PhotosUI

class ProfileViewModel: ObservableObject {
    @Published var selectedItem: PhotosPickerItem? {
        didSet {
            Task {
                try await loadImage()
            }
        }
    }
    
    @Published var image: Image?
    
    func loadImage() async throws {
        guard let item = selectedItem else { return }
        guard let imageData = try await item.loadTransferable(type: Data.self) else { return }
        guard let uiimage = UIImage(data: imageData) else { return }
        
        self.image = Image(uiImage: uiimage)
        
    }
}
