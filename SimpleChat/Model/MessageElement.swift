//
//  MessageElement.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2024/06/08.
//

import Foundation
import FirebaseFirestoreSwift

struct MessageElement: Codable, Identifiable, Equatable {
    @DocumentID var id: String?
    var name: String
    var message: String
    var createAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case message
        case createAt
    }
}
