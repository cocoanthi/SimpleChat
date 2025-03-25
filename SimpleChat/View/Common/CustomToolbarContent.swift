//
//  CustomToolbarContent.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2025/03/25.
//

import SwiftUI

struct CustomToolbarContent: ToolbarContent {
    let title: String
    let color: Color
    let placement: ToolbarItemPlacement
    
    init(_ title: String, color: Color = .white, placement: ToolbarItemPlacement = .principal) {
        self.title = title
        self.color = color
        self.placement = placement
    }
    
    var body: some ToolbarContent {
        ToolbarItem(placement: placement) {
            Text(title)
                .foregroundColor(color)
        }
    }
}
