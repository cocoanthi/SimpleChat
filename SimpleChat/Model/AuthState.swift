//
//  AuthState.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2024/06/30.
//

import Foundation

/// 認証状態
enum AuthState {
    /// 不明
    case unknown
    /// 認証済み
    case authenticated
    /// 未認証
    case unauthenticated
}
