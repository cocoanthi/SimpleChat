//
//  HistoryView.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2024/06/10.
//

import SwiftUI

struct HistoryView: View {
    /// 画面モード
    enum ViewMode {
        case history
        case delete
    }
    
    struct NavigationInfo: Hashable {
        let groupId: String
        let uid: String
        let messages: [MessageElement]
    }
    
    @StateObject var commonViewmodel = CommonViewModel.shared

    @State var path = NavigationPath()
    @State var mode: ViewMode = .history
    @State var deleteGroupIds: [String] = []

    @StateObject var viewModel: HistoryViewModel
        
    @State private var toUid: String = ""
    @State private var groupName: String = ""
        
    var body: some View {
        NavigationStack(path: $path){
            ScrollView {
                VStack(spacing: .zero) {
                    ForEach(commonViewmodel.user?.groups ?? []) { group in
                        HStack(spacing: .zero) {
                            if case .delete = mode {
                                deleteButton(group.groupId)
                            }
                            // グループ行（ボタン）
                            Button(
                                action: {
                                    // ボタン押下時、次の画面へ渡す情報を設定
                                    path.append(NavigationInfo(groupId: group.groupId, uid: viewModel.uid, messages: group.messages))
                                },
                                label: {
                                    
                                    // グループ行に表示する情報
                                    historyRow(group.name,
                                               group.messages.last?.message ?? "",
                                               group.messages.last?.createAt ?? group.createAt)
                                }
                            )
                            .disabled(mode == .delete)
                            Divider()
                        }
                    }
                }
            }
            .navigationBarTitle("履歴", displayMode: .inline)
            .backGroundModifier(color: Color.ThemeColorLevel3)
            .navigationBarBackButtonHidden(true)
            // トーク押下時の処理
            .navigationDestination(for: NavigationInfo.self, destination: { navigationInfo in
                // チャット画面へ遷移
                MessageView(groupId: navigationInfo.groupId, uid: navigationInfo.uid)
            })
            .toolbar {
                // 削除モードの場合
                if case .delete = mode {
                    // 画面左上にキャンセルボタン
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(
                            action: {
                                // 選択状態をクリア
                                deleteGroupIds.removeAll()
                                mode = .history
                            },
                            label: {
                                Image(systemName: "arrowshape.turn.up.backward")
                            }
                        )
                    }
                }
                // 画面右上にトーク削除ボタン（削除モードの場合はチェックマーク）
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        action: {
                            // 削除モードで削除ボタンを押下された場合は削除処理を行う
                            if case .delete = mode {
                                viewModel.deleteGroup(groupIds: deleteGroupIds)
                                mode = .history
                            } else {
                                mode = .delete
                            }
                        },
                        label: {
                            Image(systemName: mode == .history ? "trash" : "checkmark.circle")
                        }
                    )
                    .disabled(mode == .delete && deleteGroupIds.isEmpty)
                }
            }
        }
    }
    
    /// 削除選択ボタン
    private func deleteButton(_ groupId: String) -> some View {
        // 削除モードの場合はチェックマーク表示
        Button(
            action: {
                if deleteGroupIds.contains(groupId) {
                    // 既に存在する（選択済み）場合は削除する
                    deleteGroupIds.removeAll { $0 == groupId }
                } else {
                    // 存在しない（未選択）場合は追加する
                    deleteGroupIds.append(groupId)
                }
            },
            label: {
                // 未選択はサークル、選択時はチェックマーク
                Image(systemName: deleteGroupIds.contains(groupId) ? "checkmark.circle.fill" : "checkmark.circle")
            }
        )
        .padding()
    }

    /// グループ行
    private func historyRow(
        _ name: String,
        _ lastMsg: String,
        _ createAt: Date
    ) -> some View {
        HStack(spacing: .zero) {
            // TODO: グループアイコン的な
            Image(systemName: "photo.artframe.circle.fill")
                .padding()

            VStack(alignment: .leading, spacing: .zero) {
                HStack(spacing: .zero) {
                    // グループ名
                    Text(name)
                        .foregroundColor(.black)
                    Spacer()
                    // 最終更新時間
                    Text(clipDate(from: createAt))
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.trailing)
                }
                // 最終更新内容
                Text(lastMsg)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
    }
    
    /// 日付のフォーマット
    private func clipDate(from: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return dateFormatter.string(from: from)
    }
}
