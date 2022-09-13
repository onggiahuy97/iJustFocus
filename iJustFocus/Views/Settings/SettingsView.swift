//
//  SettingsView.swift
//  iJustFocus
//
//  Created by Huy Ong on 8/5/22.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showGestureGuide = false
    
    var body: some View {
        NavigationStack {
            List {
                SettingCellView("Goal in Minutes", "checkmark.square.fill", appViewModel.color) {
                    SetGoalView()
                }
                SettingCellView("Theme Color", "paintbrush", appViewModel.color) {
                    ColorSettingView()
                }
                SettingCellView("Timer Font", "f.square", appViewModel.color) {
                    FontDesignSettingView()
                }
                SettingCellView("Background", "photo", appViewModel.color) {
                    TimerBackgroundSettingView()
                }
                
                Toggle(isOn: $appViewModel.enableGesture) {
                    HStack {
                        Label {
                            Text("Gesture")
                        } icon: {
                            Image(systemName: "hand.draw.fill")
                                .imageScale(.large)
                                .symbolVariant(.square.fill)
                                .symbolRenderingMode(.monochrome)
                                .foregroundColor(Color(appViewModel.color))
                        }
                        Spacer()
                        Image(systemName: "info.circle")
                            .imageScale(.small)
                            .foregroundColor(Color(appViewModel.color))
                            .onTapGesture {
                                showGestureGuide.toggle()
                            }
                            .sheet(isPresented: $showGestureGuide) {
                                ShowGestureGuideView()
                            }
                    }
                }
                .tint(Color(appViewModel.color))
                
                Toggle(isOn: $appViewModel.isStatusBarHidden) {
                    HStack {
                        Label {
                            Text("Hide Status Bar")
                        } icon: {
                            Image(systemName: "antenna.radiowaves.left.and.right")
                                .imageScale(.large)
                                .symbolVariant(.square.fill)
                                .symbolRenderingMode(.monochrome)
                                .foregroundColor(Color(appViewModel.color))
                        }
                        Spacer()
                    }
                }
                .tint(Color(appViewModel.color))
            }
            .navigationTitle("Settings")
            .toolbar {
                if appViewModel.currentOrientation == .focusTimer {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss.callAsFunction()
                        }
                        .foregroundColor(Color(appViewModel.color))
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    if appViewModel.currentOrientation == .focusTodos {
                        MenuButton(false)
                    }
                }
            }
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
