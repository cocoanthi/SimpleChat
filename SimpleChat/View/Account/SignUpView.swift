//
//  SignUpView.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2024/06/09.
//

import SwiftUI

struct SignUpView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @ObservedObject var viewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("アカウント作成") {
                    viewModel.signUp(name: name, email: email, password: password)
                }
            }
            .navigationDestination(isPresented: $viewModel.isAuthenticated) {
                TopTabView(authVM: viewModel)
                    .navigationBarBackButtonHidden()
            }
            .backGroundModifier(color: Color.ThemeColorLevel3)
            .toolbar { CustomToolbarContent("アカウント作成") }
        }
    }
}
