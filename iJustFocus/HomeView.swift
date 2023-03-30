//
//  HomeView.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/19/22.
//

import SwiftUI

struct HomeView: View {
  @SceneStorage("selectedTab") var selectedTab: String?
  @EnvironmentObject var appViewModel: AppViewModel

  var timerView: TimerView
  
  var body: some View {
    TabView(selection: $selectedTab) {
      TasksView()
        .tabItem { Label("Tasks", systemImage: "checklist") }
        .tag(TasksView.tag)
      
      CalendarView()
        .tabItem { Label("Calendar", systemImage: "calendar") }
        .tag(CalendarView.tag)
      
      if appViewModel.currentOrientation == .focusTodos {
        timerView
          .tabItem {
            Label("Timer", systemImage: "timer")
          }
          .tag(TimerView.tag)
      }
      
//      HistoryTimerListView()
//        .tabItem { Label("List", systemImage: "list.bullet.clipboard") }
//        .tag(HistoryTimerListView.tag)
      
      SettingsView()
        .tabItem { Label("System", systemImage: "gear") }
        .tag(ColorSettingView.tag)
    }
  }
}

