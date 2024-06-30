//
//  HistoryView.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2024/06/10.
//

import SwiftUI

struct HistoryView: View {
    struct NavigationInfo: Hashable {
        let groupId: String
        let uid: String
        let messages: [MessageElement]
    }
    @StateObject var commonViewmodel = CommonViewModel.shared

    @State var path = NavigationPath()

    @StateObject var viewModel: HistoryViewModel
    @State private var isShowAlert: Bool = false
    @State private var toUid: String = ""
    @State private var groupName: String = ""
        
    var body: some View {
        NavigationStack(path: $path){
            ScrollView {
                VStack(spacing: .zero) {
                    ForEach(commonViewmodel.user?.groups ?? []) { group in
                        Button(
                            action: {
                                path.append(NavigationInfo(groupId: group.groupId, uid: viewModel.uid, messages: group.messages))
                            },
                            label: {
                                historyRow(group.name, group.groupId, group.createAt)
                            }
                        )
                        Divider()
                    }
                }
            }
            .backGroundModifier(color: Color.ThemeColorLevel7)
            .navigationBarTitle("履歴", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            // トーク押下時の処理
            .navigationDestination(for: NavigationInfo.self, destination: { navigationInfo in
                MessageView(groupId: navigationInfo.groupId, uid: navigationInfo.uid)
            })
            .toolbar {
                // 画面右上にトーク追加ボタン
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        action: {
                            isShowAlert.toggle()
                        },
                        label: {
                            Image(systemName: "plus.bubble.fill")
                        }
                    )
                    .alert("トーク追加", isPresented: $isShowAlert) {
                        TextField("グループ名", text: $groupName)
                        TextField("トーク相手のuid", text: $toUid)
                        Button("Cancel") { toUid = "" }
                        Button("OK") {
                            viewModel.addGroup(toUid: toUid, groupName: groupName)
                            toUid = ""
                        }
                    } message: {
                        Text("必要な情報を入力してください")
                    }
                }
            }
        }
    }
    
    private func historyRow(_ name: String, _ lastMsg: String, _ createAt: Date) -> some View {
        VStack(spacing: .zero) {
            Text(name)
            HStack(spacing: .zero) {
                Text(lastMsg)
                Text(clipDate(from: createAt))
            }
        }
    }
    
    private func clipDate(from: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return dateFormatter.string(from: from)
    }
}
