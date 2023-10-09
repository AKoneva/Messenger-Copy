//
//  TimestampExtentions.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/09.
//

import Foundation
import Firebase


extension Timestamp: Comparable {
    public static func < (lhs: Timestamp, rhs: Timestamp) -> Bool {
        return lhs.dateValue() < rhs.dateValue()
    }

    public static func == (lhs: Timestamp, rhs: Timestamp) -> Bool {
        return lhs.dateValue() == rhs.dateValue()
    }
}
