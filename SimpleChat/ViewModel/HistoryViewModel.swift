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
    enum CollectionName: String {
        case groups
        case messages
        case users
    }
    
    let uid: String
    
    /// 重複判別用ID
    private static var groupDuplicationId = ""
    private static var messageDuplicationId = ""
    
    private let db = Firestore.firestore()
    
    /// FireStore監視リスナー
    private var groupsListener: ListenerRegistration?
    private var messagesListener: ListenerRegistration?
    private var userListener: ListenerRegistration?
    
    init() {
        self.uid = Auth.auth().currentUser?.uid ?? ""
        readUser()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            self.readAllGroups()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            self.readAllMessages()
        }
    }
    
    deinit {
        groupsListener?.remove()
        messagesListener?.remove()
        userListener?.remove()
    }
    
    /// グループ削除
    /// - Parameter groupIds: 削除したいgroupId配列
    func deleteGroup(groupIds: [String]) {
        groupIds.forEach {
            db.collection(CollectionName.groups.rawValue).whereField("groupId", isEqualTo: $0).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        document.reference.delete()
                    }
                }
            }
        }
    }
    
    /// ユーザー情報取得
    private func readUser() {
        // FireStoreからユーザー情報を監視
        userListener = db.collection(CollectionName.users.rawValue)
        // FIXME: listenerで監視する必要はない
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
                            if user.uid == self.uid {
                                DispatchQueue.main.async {
                                    CommonViewModel.shared.user = user
                                }
                                // 一度ユーザー処理したら以降は監視しない
                                self.userListener?.remove()
                            }
                        } catch {
                            Logger.error(error: error)
                        }
                    }
                }
            }
    }
    
    /// ユーザーに紐づくグループ情報を取得
    private func readAllGroups() {
        // FireStoreからグループ情報を監視
        groupsListener = db.collection(CollectionName.groups.rawValue)
            .order(by: Group.CodingKeys.createAt.rawValue)
            .addSnapshotListener { (querySnapshot, error) in
                if let error {
                    Logger.error(error: error)
                    return
                }
                guard let querySnapshot else { return }
                querySnapshot.documentChanges.forEach { doc in
                    // グループ情報情報に変化（更新）があった場合
                    if doc.type == .added {
                        do {
                            let group = try doc.document.data(as: Group.self)
                            // 同じ通知が複数回飛んでくる場合があるため重複処理
                            guard Self.groupDuplicationId != group.id else { return }
                            Self.groupDuplicationId = group.id ?? ""
                            
                            // 更新があった場合都度走査しているため、重複している情報は登録しない
                            let isExist = CommonViewModel.shared.user?.groups.contains { $0.id == group.id } ?? false
                            if group.uids.contains(self.uid) && !isExist {
                                DispatchQueue.main.async {
                                    CommonViewModel.shared.user?.groups.append(group)
                                }
                            }
                        } catch {
                            Logger.error(error: error)
                        }
                    } else if doc.type == .removed {
                        do {
                            let group = try doc.document.data(as: Group.self)
                            DispatchQueue.main.async {
                                CommonViewModel.shared.user?.groups.removeAll(where: { $0.id == group.id })
                            }
                        } catch {
                            Logger.error(error: error)
                        }
                    }
                }
            }
    }
    
    private func readAllMessages() {
        // orderで作成順にソートして取得する
        messagesListener = db.collection(CollectionName.messages.rawValue)
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
                            let message = try doc.document.data(as: MessageElement.self)
                            // 同じ通知が複数回飛んでくる場合があるため重複処理
                            guard Self.messageDuplicationId != message.id else { return }
                            Self.messageDuplicationId = message.id ?? ""
                            
                            CommonViewModel.shared.user?.groups.indices.forEach {
                                if CommonViewModel.shared.user?.groups[$0].groupId == message.groupId {
                                    CommonViewModel.shared.user?.groups[$0].messages.append(message)
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
