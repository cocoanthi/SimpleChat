//
//  MessageRow.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2024/06/08.
//

import SwiftUI

struct MessageRow: View {
    let message: String
    let isMyMessage: Bool
    let date: Date
    
    var body: some View {
        HStack(spacing: .zero) {
            if isMyMessage { // 自身のメッセージ（画面右側）
                Spacer()
                VStack(alignment: .trailing, spacing: .zero) {
                    Text(message)
                        .modifier(ChatRowModifier(background: .green, foreground: .white))
                    Spacer().frame(height: 4)
                    infoContentView()
                }
            } else { // 相手のメッセージ（画面左側）
                VStack(alignment: .leading, spacing: .zero) {
                    Text(message)
                        .modifier(ChatRowModifier(background: Color(.systemGray5), foreground: .black))
                    Spacer().frame(height: 4)
                    infoContentView()
                }
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
    
    /// 送信日時
    private func infoContentView() -> some View {
        VStack(spacing: .zero) {
            if isMyMessage { // 自身が送信した日時
                Text(date.text)
                    .font(.footnote)
                    .foregroundColor(.gray)
            } else { // 相手が送信した日時
                Text(date.text)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct ChatRowModifier: ViewModifier {
    let background: Color
    let foreground: Color
    
    func body(content: Content) -> some View {
        content
            .padding(8)
            .background(background)
            .foregroundColor(foreground)
            .cornerRadius(10)
            .shadow(radius: 5)
    }
}

struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: .zero) {
            MessageRow(
                message: "Hello",
                isMyMessage: false,
                date: Date()
            )
            MessageRow(
                message: "Hello",
                isMyMessage: true,
                date: Date()
            )
        }
    }
}
