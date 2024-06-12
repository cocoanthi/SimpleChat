//
//  HistoryViewModel.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2024/06/11.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

class HistoryViewModel: ObservableObject {
    @Published private(set) var groups: [Group] = []
    private var lister: ListenerRegistration?
    private let db = Firestore.firestore()
    private let uid: String
    private let collectionName = "groups"
    private let docmentFilterName = "uids"
        
    init() {
        self.uid = Auth.auth().currentUser?.uid ?? ""
        readAllGroups()
    }
    
    deinit {
        lister?.remove()
    }
    
    func readAllGroups() {
        lister = db.collection(collectionName)
            .order(by: Group.CodingKeys.createAt.rawValue)
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
                            let group = try doc.document.data(as: Group.self)
                            if group.uids.contains(self.uid) {
                                DispatchQueue.main.async {
                                    self.groups.append(group)
                                }
                            }
                        } catch {
                            Logger.error(error: error)
                        }
                    }
                }
            }
    }
    
    func addGroup(toUid: String, groupId: String = UUID().uuidString, groupName: String, createAt: Date = Date()) {
        do {
            let group = Group(groupId: groupId, name: groupName, uids: [uid, toUid], createAt: createAt)
            try db.collection(collectionName).addDocument(from: group) { error in
                if let error = error {
                    Logger.error(error: error)
                    return
                }
                // TODO: 成功アラート表示（トースト）
                Logger.info("success")
            }
        } catch {
            Logger.error(error: error)
        }
    }
}
