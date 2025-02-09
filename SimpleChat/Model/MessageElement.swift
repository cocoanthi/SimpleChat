//
//  MessageElement.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2024/06/08.
//

import Foundation
import FirebaseFirestoreSwift

struct MessageElement: Codable, Identifiable, Equatable, Hashable {
    @DocumentID var id: String?
    /// どのグループのメッセージかを特定するためのID
    var groupId: String
    /// 誰が送信したメッセージかを特定するためのID
    var uid: String
    /// メッセージ内容
    var message: String
    /// 送信日時
    var createAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case groupId
        case uid
        case message
        case createAt
    }
}
