//
//  HomeView.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/19/22.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        TabView(selection: $appViewModel.selectedHomeViewItem) {
            TasksView()
                .tabItem { Label("Tasks", systemImage: "checklist") }
                .tag(AppViewModel.HomeViewItem.Tasks)
            
            TimersListView()
                .tabItem { Label("List", systemImage: "list.bullet.clipboard") }
                .tag(AppViewModel.HomeViewItem.Timers)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
