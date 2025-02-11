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
        case home = "ホーム"
        case history = "履歴"
        case setting = "設定"
    }
    
    @StateObject var authVM: AuthViewModel
    @StateObject private var historyVM = HistoryViewModel()
    @StateObject var homeVM = HomeViewModel()

    var body: some View {
        TabView {
            // ホーム
            HomeView(viewModel: homeVM)
                .tabItem {
                    Label(TabKind.setting.rawValue, systemImage: "house")
                }
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
