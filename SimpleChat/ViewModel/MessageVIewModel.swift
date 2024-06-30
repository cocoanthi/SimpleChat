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
    @Published var groupIndex: Int
    
    let groupId: String

    private let db = Firestore.firestore()
    private let collectionName = "messages"
        
    init(groupId: String) {
        self.groupId = groupId
        self.groupIndex = CommonViewModel.shared.user?.groups.firstIndex(where: { $0.groupId == groupId }) ?? 0
    }
    
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
