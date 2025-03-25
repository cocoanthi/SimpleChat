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
    /// ユーザーID
    var uid: String
    /// 名前
    var name: String
    /// Eメール
    var email: String
    /// 作成日時
    var createAt: Date
    /// ユーザーが持つグループチャット
    var groups: [Group] = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case uid
        case email
        case name
        case createAt
    }
}
