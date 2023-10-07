//
//  User.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/06.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable, Identifiable, Hashable {
    @DocumentID var uid: String?
    let fullName: String
    let email: String
    var profileImageURL: String?
    
    var id: String {
        return uid ?? UUID().uuidString
    }
}

extension User {
    static let MOCK_USER = User(fullName: "Anna Perekhrest", email: "anna.perekhrest@gmaol.com", profileImageURL: "Dev")
}
