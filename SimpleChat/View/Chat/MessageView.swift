//
//  MessageView.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2024/06/08.
//

import SwiftUI

struct MessageView: View {
    let uid: String
    @StateObject var commonViewModel = CommonViewModel.shared
    @StateObject private var messageVM: MessageViewModel
    @State private var typeMessage = ""
    
    init(groupId: String, uid: String) {
        self.uid = uid
        _messageVM = StateObject(wrappedValue: MessageViewModel(groupId: groupId))
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: .zero) {
                        ForEach(commonViewModel.user?.groups[safe: messageVM.groupIndex]?.messages ?? []) { message in
                            let isMyMessage = message.uid == uid
                            // メッセージ行（相手/自身両方）
                            MessageRow(
                                message: message.message,
                                isMyMessage: isMyMessage,
                                date: message.createAt
                            )
                            .id(message.id)
                        }
                    }
                    .onChange(of: commonViewModel.user?.groups[messageVM.groupIndex].messages, perform: { _ in
                        // チャットに更新があったら一番最後のログまでスクロール
                        guard let lastId = commonViewModel.user?.groups[messageVM.groupIndex].messages.last?.id else { return }
                        withAnimation {
                            proxy.scrollTo(lastId, anchor: .bottom)
                        }
                    })
                    .onAppear {
                        guard let lastId = commonViewModel.user?.groups[messageVM.groupIndex].messages.last?.id else { return }
                        proxy.scrollTo(lastId, anchor: .bottom)
                    }
                }
                .backGroundModifier(color: Color.ThemeColorLevel3)
                .onTapGesture {
                    UIApplication.shared.closeKeyboard()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { CustomToolbarContent("チャット") }
            Divider()
            // メッセージ送信画面
            inputMessageView()
                .padding()
                .background(Color.ThemeColorLevel1)
        }
    }
    
    /// メッセージ送信画面
    private func inputMessageView() -> some View {
        HStack(spacing: 4) {
            // メッセージ入力
            TextField("Message", text: $typeMessage)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            // 送信ボタン
            Button {
                guard !typeMessage.isEmpty else { return }
                messageVM.addMessage(message: typeMessage, uid: uid)
                UIApplication.shared.closeKeyboard()
                typeMessage = ""
            } label: {
                Image(systemName: "arrow.up.circle.fill")
            }
        }
        .animation(.default)
    }
}
