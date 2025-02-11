//
//  SettingView.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2024/06/10.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject var viewModel: AuthViewModel
    private static let COULD_NOT_GET = "取得できませんでした"
    
    var body: some View {
        VStack(spacing: .zero) {
            Spacer()
            // ユーザー情報
            HStack(spacing: .zero) {
                VStack(spacing: 6) {
                    userItem(title: "Account : ", content: CommonViewModel.shared.user?.name)
                    userItem(title: "Email : ", content: CommonViewModel.shared.user?.email)
                    userItem(title: "ID : ", content: CommonViewModel.shared.user?.uid)
                }
                Spacer()
            }
            Spacer()
            // ログアウト
            Button("ログアウト") {
                viewModel.signOut()
            }
            .buttonStyle(.bordered)
            Spacer()
        }
    }
    
    /// ユーザー情報表示部分
    /// - Parameters:
    ///   - title: 項目のタイトル
    ///   - content: 項目の内容。nilの場合は”取得できませんでした”
    /// - Returns: ユーザー情報表示画面
    @ViewBuilder
    private func userItem(title: String, content: String?) -> some View {
        HStack(spacing: .zero) {
            Text(title)
                .frame(maxWidth: (UIScreen.main.bounds.width/2)/2, alignment: .trailing)
            Text(content ?? Self.COULD_NOT_GET)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(viewModel: .init())
    }
}
