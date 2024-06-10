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
    let user: String
    let date: Date
    
    var body: some View {
        HStack(spacing: .zero) {
            if isMyMessage {
                Spacer()
                VStack(alignment: .trailing, spacing: .zero) {
                    Text(message)
                        .modifier(ChatRowModifier(background: .green, foreground: .white))
                    Spacer().frame(height: 4)
                    infoContentView()
                }
            } else {
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
    
    private func infoContentView() -> some View {
        Group {
            if isMyMessage {
                Text(date.text)
                    .font(.footnote)
                    .foregroundColor(.gray)
            } else {
                HStack(spacing: .zero) {
                    Text(user)
                        .font(.footnote)
                    Spacer().frame(width: 8)
                    Text(date.text)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
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
                user: "Foo",
                date: Date()
            )
            MessageRow(
                message: "Hello",
                isMyMessage: true,
                user: "Bar",
                date: Date()
            )
        }
    }
}
