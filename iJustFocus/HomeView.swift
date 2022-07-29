//
//  HomeView.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/19/22.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @Environment(\.colorScheme) private var colorScheme
    
    @SceneStorage("selectedTab") var selectedTab: String?
        
    var body: some View {
        TabView(selection: $selectedTab) {
            TasksView()
                .tabItem { Label("Tasks", systemImage: "checklist") }
                .tag(TasksView.tag)
            
            HistoryTimerListView()
                .tabItem { Label("List", systemImage: "list.bullet.clipboard") }
                .tag(HistoryTimerListView.tag)
            
            SettingView()
                .tabItem { Label("System", systemImage: "gear") }
                .tag(SettingView.tag)
            
        }
        .onAppear(perform: configNav)
        .onChange(of: appViewModel.color) { _ in configNav() }
        .onChange(of: colorScheme) { _ in configNav() }
        .accentColor(Color(appViewModel.color))
    }
    
    func configNav() {
        let color = (appViewModel.color == UIColor.black && colorScheme == .dark) ? UIColor.white : appViewModel.color
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: color]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: color]
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
