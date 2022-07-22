//
//  SettingView.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/22/22.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var colorPicker: some View {
        List {
            ForEach(appViewModel.colors) { color in
                Button {
                    appViewModel.color = color.uiColor
                } label: {
                    Label(color.text, systemImage: "square.fill")
                        .foregroundColor(Color(color.uiColor))
                }
            }
        }
    }
    
    var body: some View {
        colorPicker
    }
}

extension SettingView {
    static let tag: String? = "SettingView"
}
