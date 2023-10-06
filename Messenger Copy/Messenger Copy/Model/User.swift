//
//  User.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/06.
//

import Foundation

struct User: Codable, Identifiable, Hashable {
    var id = UUID().uuidString
    let fullName: String
    let email: String
    var profileImageURL: String?
}

extension User {
    static let MOCK_USER = User(fullName: "Anna Perekhrest", email: "anna.perekhrest@gmaol.com", profileImageURL: "Dev")
}
