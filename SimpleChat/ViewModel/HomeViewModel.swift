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
    /// ユーザー選択によって作成されたグループ
    @Published var createdGroup: Group?
    
    /// 全ユーザー
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
    
    /// グループ情報追加。すでに重複したグループがある場合は追加しない。
    /// - Parameters:
    ///   - myUid: 自身のUID
    ///   - toUid: チャット相手のUID
    ///   - groupId: 登録するID
    ///   - groupName: 登録するグループ名
    ///   - createAt: 作成日時
    func addGroup(
        user: User?,
        toUid: String?,
        groupId: String = UUID().uuidString,
        groupName: String?,
        createAt: Date = Date()
    ) {
        guard let user, let toUid, let groupName else {
            Logger.error("addGroup failure.")
            // TODO: 失敗アラート表示
            return
        }
        
        // 重複したグループがあるか確認
        let newGroup : Set = [user.uid, toUid]
        let existsGroup: Group? = user.groups.filter {
            let existGroup: Set = Set($0.uids)
            return newGroup == existGroup
        }.first
        
        // グループが存在する場合は存在するグループをプロパティに入れて早期return
        if let existsGroup {
            createdGroup = existsGroup
            return
        }
        
        // グループが存在しない場合は新規に登録
        let group = Group(groupId: groupId, name: groupName, uids: [user.uid, toUid], createAt: createAt)
        do {
            try db.collection(CollectionName.groups.rawValue).addDocument(from: group) { error in
                if let error = error {
                    // TODO: 失敗アラート表示
                    Logger.error(error: error)
                    return
                }
                self.createdGroup = group
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
