//
//  AuthViewModel.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2024/06/09.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    /// 認証状態
    @Published var authState = AuthState.unknown {
        willSet {
            switch newValue {
            case .authenticated:
                isAuthenticated = true
            case .unauthenticated, .unknown:
                isAuthenticated = false
            }
        }
    }
    /// 認証されているか
    @Published var isAuthenticated: Bool = false
    /// アラート表示するか
    @Published var showsAlert = false
    /// ユーザー情報を取得するためのキー
    private let collectionName = "users"

    init() {
        observeAuthChanges()
    }
    
    /// 認証状態を監視する
    private func observeAuthChanges() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.authState = (user != nil) ? .authenticated : .unauthenticated
            }
        }
    }
    
    /// サインインする
    /// - Parameters:
    ///   - email: Email
    ///   - password: パスワード
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if result != nil, error == nil {
                    self?.authState = .authenticated
                } else {
                    // サインインできなかった場合はアラート表示
                    self?.showsAlert = true
                }
            }
        }
    }
    
    /// サインアップ（登録）
    /// - Parameters:
    ///   - name: 登録したい名前
    ///   - email: 登録したいEmail
    ///   - password: 登録したいパスワード
    func signUp(name: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if result != nil, error == nil {
                    self?.authState = .authenticated
                    // 登録成功した場合はFireStoreへユーザー情報を保存
                    self?.addUser(name: name, email: email)
                } else {
                    // 登録失敗した場合はアラート表示
                    self?.showsAlert = true
                }
            }
        }
    }
    
    /// パスワードをリセットする
    /// - Parameter email: パスワードリセットしたい登録されたEmail
    func resetPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("Error in sending password reset: \(error)")
            }
        }
    }
    
    /// サインアウト
    func signOut() {
        do {
            try Auth.auth().signOut()
            authState = .unauthenticated
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    /// ユーザー情報をFireStoreへ登録する
    /// - Parameters:
    ///   - name: FireStoreへ登録したい名前
    ///   - email: FireStoreへ登録したいEmail
    ///   - createAt: FireStoreへ登録する日付
    private func addUser(name: String, email: String, createAt: Date = Date()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            Logger.error("userID not found")
            return
        }

        do {
            let user = User(uid: uid, name: name, email: email, createAt: createAt, groups: [])
            let db = Firestore.firestore()
            // FireStoreへ登録
            try db.collection(collectionName).addDocument(from: user) { error in
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
