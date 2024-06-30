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

    @Published var isAuthenticated: Bool = false
    @Published var showsAlert = false
    private let collectionName = "users"

    init() {
        observeAuthChanges()
    }
    
    private func observeAuthChanges() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.authState = (user != nil) ? .authenticated : .unauthenticated
            }
        }
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if result != nil, error == nil {
                    self?.authState = .authenticated
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
                    self?.authState = .authenticated
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
            authState = .unauthenticated
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
            }
        } catch {
            Logger.error(error: error)
        }
    }
}
