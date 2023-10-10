//
//  ImageCached.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/10.
//

import Foundation
import SwiftUI

class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSString, UIImage>()
    
    func image(for key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }
    
    func insertImage(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}
