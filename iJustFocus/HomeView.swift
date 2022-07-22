//
//  HomeView.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/19/22.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    
    @SceneStorage("selectedTab") var selectedTab: String?
        
    var body: some View {
        TabView(selection: $selectedTab) {
            TasksView()
                .tabItem { Label("Tasks", systemImage: "checklist") }
                .tag(TasksView.tag)
            
            TimersListView()
                .tabItem { Label("List", systemImage: "list.bullet.clipboard") }
                .tag(TimersListView.tag)
            
            SettingView()
                .tabItem { Label("System", systemImage: "gear") }
                .tag(SettingView.tag)
            
        }
        .onAppear(perform: configNav)
        .onChange(of: appViewModel.color) { _ in configNav() }
        .accentColor(Color(appViewModel.color))
    }
    
    func configNav() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: appViewModel.color]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: appViewModel.color]
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
