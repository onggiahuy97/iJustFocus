//
//  SettingView.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/22/22.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State private var bgColor = Color.white
    
    var colorPicker: some View {
        ForEach(AppViewModel.colors) { color in
            Button {
                appViewModel.color = color.uiColor
            } label: {
                colorCell(color)
            }
        }
    }
    
    var customColor: some View {
        Button {
            appViewModel.color = UIColor(bgColor)
        } label: {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [bgColor.opacity(0.75), bgColor],
                        startPoint: .top,
                        endPoint: .bottom)
                )
                .frame(height: 120)
        }
        .overlay(alignment: .leading) {
            ColorPicker("Pick a color", selection: $bgColor)
                .padding()
                .foregroundColor(.white)
                .font(.system(size: 16))
                .onAppear {
                    bgColor = Color(appViewModel.color)
                }
                .onChange(of: bgColor) { newValue in
                    appViewModel.color = UIColor(bgColor)
                }
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                colorPicker
                customColor
            }
        }
    }
    
    func colorCell(_ color: AppViewModel.Coloring) -> some View {
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

extension SettingView {
    static let tag: String? = "SettingView"
}
