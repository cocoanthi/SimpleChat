//
//  MasterUserData.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2024/06/20.
//

import Foundation

struct MasterUserData: Codable, Equatable {
    var user: User
    var group: Group?
    var messageElement: MessageElement?
    
    enum CodingKeys: String, CodingKey {
        case user
        case group
        case messageElement
    }
}
