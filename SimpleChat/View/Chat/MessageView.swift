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
    @State private var scrolled = false
    
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
                            MessageRow(
                                message: message.message,
                                isMyMessage: message.uid == uid,
                                user: "test",
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
                .onTapGesture {
                    UIApplication.shared.closeKeyboard()
                }
            }
            .navigationBarTitle("Chats", displayMode: .inline)
            
            Divider()
            inputMessageView()
                .padding()
        }
    }
    
    private func inputMessageView() -> some View {
        HStack(spacing: 4) {
            TextField("Message", text: $typeMessage)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button {
                guard !typeMessage.isEmpty else { return }
                messageVM.addMessage(message: typeMessage, uid: uid)
                typeMessage = ""
                UIApplication.shared.closeKeyboard()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
            }
        }
        .animation(.default)
    }
}
