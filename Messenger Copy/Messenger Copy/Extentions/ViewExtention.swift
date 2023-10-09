//
//  ViewExtention.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/09.
//

import Foundation
import SwiftUI

extension View {
    func getRootController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .init() }
        
        guard let root = screen.windows.first?.rootViewController else { return .init() }
        
        return root
    }
}
