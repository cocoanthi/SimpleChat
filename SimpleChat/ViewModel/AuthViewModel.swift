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
    @Published var isAuthenticated = false
    @Published var showsAlert = false
    private let collectionName = "users"

    init() {
        observeAuthChanges()
    }
    
    private func observeAuthChanges() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isAuthenticated = user != nil
            }
        }
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if result != nil, error == nil {
                    self?.isAuthenticated = true
                } else {
                    self?.showsAlert = true
                }
            }
        }
    }
    
    func signUp(name: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if result != nil, error == nil {
                    self?.isAuthenticated = true
                    self?.addUser(name: name, email: email)
                } else {
                    self?.showsAlert = true
                }
            }
        }
    }

    func resetPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("Error in sending password reset: \(error)")
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    private func addUser(name: String, email: String, createAt: Date = Date()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            Logger.error("userID not found")
            return
        }

        do {
            let user = User(uid: uid, name: name, email: email, createAt: createAt, groups: [])
            let db = Firestore.firestore()

            try db.collection(collectionName).addDocument(from: user) { error in
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
