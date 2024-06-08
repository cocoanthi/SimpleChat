//
//  Date+.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2024/06/08.
//

import Foundation

extension Date {
    var text: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: self)
    }
}
