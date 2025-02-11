//
//  HomeView.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2025/02/11.
//

import SwiftUI

struct HomeView: View {
    struct NavigationInfo: Hashable {
        let groupId: String
        let uid: String
        let messages: [MessageElement]
    }
    @StateObject var commonViewmodel = CommonViewModel.shared
    @StateObject var viewModel: HomeViewModel
    
    @State var path = NavigationPath()

    @State private var isShowAlert: Bool = false
        
    var body: some View {
        NavigationStack(path: $path){
            ScrollView {
                VStack(spacing: .zero) {
                    // ユーザー一覧
                    ForEach(viewModel.users) { user in
                        // ユーザー行（ボタン）
                        Button(
                            action: {
                                // チャット画面へ遷移する確認アラート表示
                                isShowAlert.toggle()
                            },
                            label: {
                                // グループ行に表示する情報
                                Text(user.name)
                                    .padding()
                            }
                        )
                        Divider()
                    }
                }
            }
            .backGroundModifier(color: Color.ThemeColorLevel7)
            .navigationBarTitle("ホーム", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            // トーク押下時の処理
            .navigationDestination(for: NavigationInfo.self, destination: { navigationInfo in
                // チャット画面へ遷移
                MessageView(groupId: navigationInfo.groupId, uid: navigationInfo.uid)
            })
            .alert("[]さんとチャットしますか", isPresented: $isShowAlert) {
                Button("Cancel") { isShowAlert.toggle() }
                Button("OK") {
                    // FIXME: インジケーター表示したい
                    // addGroup必要
                    
                    // 次の画面へ渡す情報を設定
//                    path.append(NavigationInfo(groupId: group.groupId, uid: viewModel.uid, messages: group.messages))
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: .init())
    }
}
