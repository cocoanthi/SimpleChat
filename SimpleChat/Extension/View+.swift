//
//  View+.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2024/07/01.
//

import SwiftUI

struct BackGroundColorModifier: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        ZStack() {
            color
            content
        }
    }
}

extension View {
    func backGroundModifier(color: Color) -> some View {
        modifier(BackGroundColorModifier(color: color))
    }
}
