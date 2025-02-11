//
//  HomeViewModel.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2025/02/12.
//

import Foundation
import Combine
import FirebaseFirestore

class HomeViewModel: ObservableObject {
    enum CollectionName: String {
        case groups
        case users
    }

    var users: [User] = []
    
    
    private let db = Firestore.firestore()
    
    /// FireStore監視リスナー
    private var userListener: ListenerRegistration?
    
    init() {
        readAllUser()
    }
    
    deinit {
        userListener?.remove()
    }
    
    func addGroup(toUid: String, groupId: String = UUID().uuidString, groupName: String, createAt: Date = Date()) {
        guard let uid = CommonViewModel.shared.user?.uid else {
            Logger.error("uid not found")
            return
        }
        do {
            let group = Group(groupId: groupId, name: groupName, uids: [uid, toUid], createAt: createAt)
            try db.collection(CollectionName.groups.rawValue).addDocument(from: group) { error in
                if let error = error {
                    Logger.error(error: error)
                    return
                }
                // TODO: 成功アラート表示
                Logger.info("success")
            }
        } catch {
            // TODO: 失敗アラート表示
            Logger.error(error: error)
        }
    }
    
    /// ユーザー情報取得
    private func readAllUser() {
        // FireStoreからユーザー情報を監視
        userListener = db.collection(CollectionName.users.rawValue)
            .addSnapshotListener { (querySnapshot, error) in
                if let error {
                    Logger.error(error: error)
                    return
                }
                guard let querySnapshot else { return }
                querySnapshot.documentChanges.forEach { doc in
                    // ユーザー情報に変化（更新）があった場合
                    if doc.type == .added {
                        do {
                            let user = try doc.document.data(as: User.self)
                            // 重複しないようにusersの中身を見る
                            if !self.users.contains(user) {
                                DispatchQueue.main.async {
                                    self.users.append(user)
                                }
                            }
                        } catch {
                            Logger.error(error: error)
                        }
                    }
                }
            }
    }
}
