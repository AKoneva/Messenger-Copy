//
//  CircleProfileImageView.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/07.
//

import SwiftUI
import CachedAsyncImage

enum ProfileImageSize {
    case xxSmall
    case xSmall
    case small
    case medium
    case large
    case xLarge
    
    var dimantion: CGFloat {
        switch self {
        case .xxSmall:
            return 28
        case .xSmall:
            return 32
        case .small:
            return 40
        case .medium:
            return 56
        case .large:
            return 64
        case .xLarge:
            return 80
        }
    }
}

struct CircleProfileImageView: View {
    var profileImageURL: String
    let size: ProfileImageSize
    
    var cacheBustedURL: URL? {
            guard let url = URL(string: profileImageURL) else { return nil }
            let timestamp = Date().timeIntervalSince1970
            return url.appendingPathComponent("?t=\(timestamp)")
        }
    
    var body: some View {
        if let cachedImage = ImageCache.shared.image(for: profileImageURL) {
            Image(uiImage: cachedImage)
                .resizable()
                .scaledToFill()
                .frame(width: size.dimantion, height: size.dimantion)
                .clipShape(Circle())
        } else {
            AsyncImage(url: URL(string: profileImageURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.dimantion, height: size.dimantion)
                    .clipShape(Circle())
            } placeholder: {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: size.dimantion, height: size.dimantion)
                    .foregroundColor(.gray)
            }
            .onAppear {
                loadImage()
            }
        }
    }
    
    private func loadImage() {
        if let url = URL(string: profileImageURL) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data, let image = UIImage(data: data) {
                    ImageCache.shared.insertImage(image, for: profileImageURL)
                }
            }.resume()
        }
    }
}

#Preview {
    CircleProfileImageView(profileImageURL: User.MOCK_USER.profileImageURL, size: .medium)
}
