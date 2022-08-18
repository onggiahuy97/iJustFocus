//
//  HomeView.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/19/22.
//

import SwiftUI

struct HomeView: View {
    @SceneStorage("selectedTab") var selectedTab: String?
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TasksView()
                .tabItem { Label("Tasks", systemImage: "checklist") }
                .tag(TasksView.tag)
            
            HistoryTimerListView()
                .tabItem { Label("List", systemImage: "list.bullet.clipboard") }
                .tag(HistoryTimerListView.tag)
            
            SettingsView()
                .tabItem { Label("System", systemImage: "gear") }
                .tag(ColorSettingView.tag)
        }
    }
}

