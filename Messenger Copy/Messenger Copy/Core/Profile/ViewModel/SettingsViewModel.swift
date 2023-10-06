//
//  SettingsViewModel.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/06.
//

import Foundation
import SwiftUI

enum SettingsViewModel: Int, CaseIterable, Identifiable {
    case darkMode
    case activeStatus
    case accsessability
    case privacy
    case notifications
    
    var id: Int { return self.rawValue }
    
    var title: String {
        switch self {
        case .darkMode:
            return "Dark mode"
        case .activeStatus:
            return "Active status"
        case .accsessability:
            return "Accsessability"
        case .privacy:
            return "Privacy"
        case .notifications:
            return "Notifications"
        }
    }
    
    var imageName: String {
        switch self {
        case .darkMode:
            return "moon.circle.fill"
        case .activeStatus:
            return "message.circle.fill"
        case .accsessability:
            return "person.circle.fill"
        case .privacy:
            return "lock.circle.fill"
        case .notifications:
            return "bell.circle.fill"
        }
    }
    
    var imageBackgroundColor: Color {
        switch self {
        case .darkMode:
            return Color.primary
        case .activeStatus:
            return Color.green
        case .accsessability:
            return Color.primary
        case .privacy:
            return Color.blue
        case .notifications:
            return Color.purple
        }
    }
}
