//
//  MessageVIewModel.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2024/06/08.
//

import Foundation
import Combine
import FirebaseFirestore

class MessageViewModel: ObservableObject {
    /// 対象のGroupを特定するためのindex
    @Published var groupIndex: Int
    /// 対象のグループID
    let groupId: String

    private let db = Firestore.firestore()
    private let collectionName = "messages"
        
    init(groupId: String) {
        self.groupId = groupId
        self.groupIndex = CommonViewModel.shared.user?.groups.firstIndex(where: { $0.groupId == groupId }) ?? 0
    }
    
    /// メッセージを追加（送信）する
    /// - Parameters:
    ///   - message: メッセージ内容
    ///   - uid: 追加したuid
    ///   - createAt: 追加した日時
    func addMessage(message: String , uid: String, createAt: Date = Date()) {
        do {
            let message = MessageElement(groupId: groupId, uid: uid, message: message, createAt: createAt)
            try db.collection(collectionName).addDocument(from: message) { error in
                if let error = error {
                    Logger.error(error: error)
                    return
                }
            }
        } catch {
            Logger.error(error: error)
        }
    }    
}
