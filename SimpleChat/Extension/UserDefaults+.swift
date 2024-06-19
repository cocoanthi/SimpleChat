//
//  UserDefaults+.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2024/06/20.
//

import Foundation

@propertyWrapper
struct Storage<T: Codable> {
    private let key: String
    private let defaultValue: T
    private let userdef: UserDefaults
 
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
        userdef = UserDefaults.standard
    }
 
    var wrappedValue: T {
        get {
            // UserDefaults にデータがなければデフォルト値を返す
            guard let data = userdef.object(forKey: key) as? Data else {
                return defaultValue
            }
            // データを取得
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        } set {
            let data = try? JSONEncoder().encode(newValue)
            userdef.set(data, forKey: key)
        }
    }
}
 
/// UserDefaults に格納するプロパティを定義する構造体
struct AppData {
    /// Bool や Int などの基本型以外も格納できる（Codable に準拠している場合のみ）
    @Storage(key: "masterUserData", defaultValue: nil)
    static var hoge: MasterUserData?
}
