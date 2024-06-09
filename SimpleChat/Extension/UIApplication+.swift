//
//  UIApplication+.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2024/06/09.
//

import UIKit

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
