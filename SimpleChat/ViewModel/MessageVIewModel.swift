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
    @Published private(set) var messages: [MessageElement] = []

    private var lister: ListenerRegistration?
    private let db = Firestore.firestore()
    /// コレクションの名称
    private let collectionName = "messages"
        
    init() {
        readAllMessages()
    }
    
    deinit {
        lister?.remove()
    }
    
    func readAllMessages() {
        // orderで作成順にソートして取得する
        lister = db.collection(collectionName)
            .order(by: MessageElement.CodingKeys.createAt.rawValue)
            .addSnapshotListener { (querySnapshot, error) in
                if let error {
                    Logger.error(error: error)
                    return
                }
                guard let querySnapshot else { return }
                querySnapshot.documentChanges.forEach { doc in
                    if doc.type == .added {
                        do {
                            // Codableを使って構造体に変換する
                            let message = try doc.document.data(as: MessageElement.self)
                            DispatchQueue.main.async {
                                self.messages.append(message)
                            }
                        } catch {
                            Logger.error(error: error)
                        }
                    }
                }
            }
    }
    
    func addMessage(message: String , name: String, createAt: Date = Date()) {
        do {
            let message = MessageElement(name: name, message: message, createAt: createAt)
            try db.collection(collectionName).addDocument(from: message) { error in
                if let error = error {
                    Logger.error(error: error)
                    return
                }
                Logger.info("success")
            }
        } catch {
            Logger.error(error: error)
        }
    }
}
