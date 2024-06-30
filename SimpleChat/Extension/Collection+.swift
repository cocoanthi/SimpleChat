//
//  Collection.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2024/06/24.
//

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
