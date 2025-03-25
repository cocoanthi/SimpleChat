//
//  View+.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2024/07/01.
//

import SwiftUI

/// 背景色のモディファイア
struct BackGroundColorModifier: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        ZStack() {
            color
            content
        }
    }
}

/// プログレス表示のモディファイア
struct CustomProgressView: ViewModifier {
    let text: String?
    @Binding var showsProgressView: Bool

    func body(content: Content) -> some View {
        ZStack { content
            if showsProgressView {
                // 透明なColorを敷いて背景をタップ不可にする
                Color.gray.opacity(0.2)

                VStack(spacing: 6) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                    Text(text ?? "")
                        .foregroundColor(Color.gray)
                        .font(.caption2)
                }
            }
        }
    }
}

extension View {
    func backGroundModifier(color: Color) -> some View {
        modifier(BackGroundColorModifier(color: color))
    }
    
    func customProgressView(_ showsProgressView: Binding<Bool>, text: String? = nil) -> some View {
        self.modifier(CustomProgressView(text: text, showsProgressView: showsProgressView))
    }
}
