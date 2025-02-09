//
//  HelloPage.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2024/06/09.
//

import SwiftUI

// ログイン後の画面
struct TopTabView: View {
    enum TabKind: String {
        case history = "履歴"
        case setting = "設定"
    }
    
    @StateObject var authVM: AuthViewModel
    @StateObject private var historyVM = HistoryViewModel()

    var body: some View {
        TabView {
            // メッセージ一覧
            HistoryView(viewModel: historyVM)
                .tabItem {
                    Label(TabKind.history.rawValue, systemImage: "clock")
                }
            // 設定
            SettingView(viewModel: authVM)
                .tabItem {
                    Label(TabKind.setting.rawValue, systemImage: "gearshape")
                }
        }
    }
}
