//
//  SimpleChatApp.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2024/06/08.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct SimpleChatApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var viewModel = AuthViewModel()
    
    // バー系は全て統一したいためUIKitで設定
    init() {
        let tabAppearance: UITabBarAppearance = UITabBarAppearance()
        tabAppearance.backgroundColor = UIColor(Color.ThemeColorLevel1)
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance
        UITabBar.appearance().standardAppearance = tabAppearance
        
        let barAppearance: UINavigationBarAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = UIColor(Color.ThemeColorLevel2)
        UINavigationBar.appearance().scrollEdgeAppearance = barAppearance
        UINavigationBar.appearance().standardAppearance = barAppearance
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                // ログイン状態によって画面遷移するページを変更する
                switch viewModel.authState {
                case .authenticated:
                    TopTabView(authVM: viewModel)
                case .unauthenticated:
                    SignInView(viewModel: viewModel)
                case .unknown:
                    EmptyView()
                }
            }
        }
    }
}
