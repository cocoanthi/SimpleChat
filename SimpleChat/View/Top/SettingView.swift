//
//  SettingView.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2024/06/10.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject var viewModel: AuthViewModel

    var body: some View {
        VStack {
            Button("Log Out") {
                viewModel.signOut()
            }
        }
    }
}
