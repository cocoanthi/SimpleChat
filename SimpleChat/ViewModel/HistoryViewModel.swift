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
            
    private static var groupDuplicationId = ""
    private static var messageDuplicationId = ""
    private let db = Firestore.firestore()

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
    
    private func readUser() {
        userListener = db.collection(CollectionName.users.rawValue)
        // FIXME: listenerで監視する必要はない
            .addSnapshotListener { (querySnapshot, error) in
                if let error {
                    Logger.error(error: error)
                    return
                }
                guard let querySnapshot else { return }
                querySnapshot.documentChanges.forEach { doc in
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
    
    private func readAllGroups() {
        groupsListener = db.collection(CollectionName.groups.rawValue)
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
                            let group = try doc.document.data(as: Group.self)
                            // 同じ通知が複数回飛んでくる場合があるため重複処理
                            guard Self.groupDuplicationId != group.id else { return }
                            Self.groupDuplicationId = group.id ?? ""

                            let isExist = CommonViewModel.shared.user?.groups.contains { target in
                                if target.id == group.id {
                                    return true
                                } else {
                                    return false
                                }
                            } ?? false
                            // 二重登録はしない
                            if group.uids.contains(self.uid) && !isExist {
                                DispatchQueue.main.async {
                                    CommonViewModel.shared.user?.groups.append(group)
                                }
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
    
    func addGroup(toUid: String, groupId: String = UUID().uuidString, groupName: String, createAt: Date = Date()) {
        do {
            let group = Group(groupId: groupId, name: groupName, uids: [uid, toUid], createAt: createAt)
            try db.collection(CollectionName.groups.rawValue).addDocument(from: group) { error in
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
