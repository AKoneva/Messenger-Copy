//
//  CircleProfileImageView.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/07.
//

import SwiftUI

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
    var user: User?
    let size: ProfileImageSize
    
    var body: some View {
        if let url = user?.profileImageURL {
            Image(url)
                .resizable()
                .scaledToFill()
                .frame(width: size.dimantion, height: size.dimantion)
                .clipShape(Circle())
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: size.dimantion, height: size.dimantion)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    CircleProfileImageView(user: User.MOCK_USER, size: .medium)
}
