//
//  MessageElement.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2024/06/08.
//

import Foundation
import FirebaseFirestoreSwift

struct MessageElement: Codable {
    @DocumentID var id: String?
    var name: String
    var message: String
    var createAt: Date
}
