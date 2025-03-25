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
    /// グループを特定するためのID
    var groupId: String
    /// グループ名
    var name: String
    /// グループに参加しているユーザー
    /// Firebase Authで取得できるid
    var uids: [String]
    /// グループの作成日時
    var createAt: Date
    /// チャットの内容
    var messages: [MessageElement] = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case groupId
        case name
        case uids
        case createAt
    }
}
