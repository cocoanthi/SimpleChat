//
//  User.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2024/06/10.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable, Identifiable, Equatable {
    @DocumentID var id: String?
    var uid: String
    var name: String
    var email: String
    var createAt: Date
    /// UUID.uuidStringを想定
    var groups: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case uid
        case email
        case name
        case createAt
        case groups
    }
}
