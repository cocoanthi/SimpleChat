//
//  SignInView.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2024/06/09.
//

import SwiftUI

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State var path = NavigationPath()
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        TabView {
            NavigationStack(path: $path){
                VStack {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button("サインイン") {
                        viewModel.signIn(email: email, password: password)
                    }
                    .alert("サインインできませんでした", isPresented: $viewModel.showsAlert) {
                    } message: {
                        Text("認証に失敗しました")
                    }
                    
                    if viewModel.authState == .authenticated {
                        // ログイン後のページに遷移
                        TopTabView(authVM: viewModel)
                    }
                    
                    // 新規登録画面への遷移ボタン
                    NavigationLink(destination: SignUpView(viewModel: viewModel)) {
                        Text("アカウント作成")
                            .padding(.top, 16)
                    }
                    // パスワードのリセットページへ移動する
                    NavigationLink(destination: ResetPasswordView(viewModel: viewModel)) {
                        Text("パスワードリセット")
                            .padding(.top, 16)
                    }
                }
                .backGroundModifier(color: Color.ThemeColorLevel3)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { CustomToolbarContent("サインイン") }
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}
