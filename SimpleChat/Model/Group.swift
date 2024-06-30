//
//  Group.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2024/06/11.
//

import Foundation
import FirebaseFirestoreSwift

struct Group: Codable, Identifiable, Equatable {
    @DocumentID var id: String?
    /// UUID.uuidStringを想定
    var groupId: String
    var name: String
    /// Firebase Authで取得できるid
    var uids: [String]
    var createAt: Date
    
    var messages: [MessageElement] = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case groupId
        case name
        case uids
        case createAt
    }
}
