//
//  SettingsView.swift
//  iJustFocus
//
//  Created by Huy Ong on 8/5/22.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appViewModel: AppViewModel
        
    var body: some View {
        NavigationStack {
            List {
                SettingCellView("Theme Color", "paintbrush", appViewModel.color) {
                    ColorSettingView()
                }
                SettingCellView("Timer Font", "f.square", appViewModel.color) {
                    FontDesignSettingView()
                }
                SettingCellView("Background", "photo", appViewModel.color) {
                    TimerBackgroundSettingView()
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingCellView<Content: View>: View {
    let title: String
    let systemImage: String
    let iconColor: UIColor
    let content: () -> Content
    
    init(_ title: String,
         _ systemImage: String,
         _ iconColor: UIColor = .black,
         _ content: @escaping () -> Content
    ) {
        self.title = title
        self.systemImage = systemImage
        self.iconColor = iconColor
        self.content = content
    }
    
    var label: some View {
        Label {
            Text(title)
        } icon: {
            Image(systemName: systemImage)
                .imageScale(.large)
                .symbolVariant(.square.fill)
                .symbolRenderingMode(.monochrome)
                .foregroundColor(Color(iconColor))
        }
    }
    
    var body: some View {
        NavigationLink(destination: content) { label }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
