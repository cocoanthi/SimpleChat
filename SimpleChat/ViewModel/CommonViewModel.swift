//
//  CommonViewModel.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2024/06/25.
//

import Foundation

class CommonViewModel: ObservableObject {
    static var shared = CommonViewModel()
    @Published var user: User?
    
    private init() {}
}
