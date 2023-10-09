//
//  DateExtentions.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/09.
//

import Foundation

extension Date {
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateFormat = "dd/MM/yy"
        return formatter
    }
    
    private func timeString() -> String {
        timeFormatter.string(from: self)
    }
    
    private func dateString() -> String {
        dayFormatter.string(from: self)
    }
    
     func timestampString() -> String {
        if Calendar.current.isDateInToday(self) {
            return timeString()
        } else if Calendar.current.isDateInYesterday(self) {
            return "Yesterday"
        } else {
            return dateString()
        }
    }
}
