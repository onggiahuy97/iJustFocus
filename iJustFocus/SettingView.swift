//
//  SettingView.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/22/22.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    let columns: [GridItem] = Array.init(repeating: GridItem(.flexible()), count: 1)
    
    var colorPicker: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(AppViewModel.colors) { color in
                Button {
                    appViewModel.color = color.uiColor
                } label: {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color(color.uiColor).opacity(0.75), Color(color.uiColor)],
                                startPoint: .top,
                                endPoint: .bottom)
                        )
                        .frame(height: 120)
                        .overlay(alignment: .leading) {
                            Text(color.text)
                                .padding()
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                        }
                }
            }
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            colorPicker
        }
    }
}

extension SettingView {
    static let tag: String? = "SettingView"
}
