//
//  iJustFocusApp.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/5/22.
//

import SwiftUI

@main
struct iJustFocusApp: App {
    @StateObject var dataController: DataController
    @StateObject var timerViewModel: TimerViewModel
    @StateObject var tasksViewModel: TaskViewModel
    @StateObject var appViewModel: AppViewModel
    
    @Environment(\.colorScheme) private var colorScheme
    
    init() {
        let dataController = DataController()
        _appViewModel = StateObject(wrappedValue: .init())
        _dataController = StateObject(wrappedValue: dataController)
        _timerViewModel = StateObject(wrappedValue: .init(dataController: dataController))
        _tasksViewModel = StateObject(wrappedValue: .init(dataController: dataController))
    }
    
    var drag: some Gesture {
        DragGesture()
            .onEnded(appViewModel.calculateGestureOnEnded(_:))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .persistentSystemOverlays(.hidden)
                .environmentObject(timerViewModel)
                .environmentObject(tasksViewModel)
                .environmentObject(appViewModel)
                .environmentObject(dataController)
                .environment(\.managedObjectContext, DataController.shared.container.viewContext)
                .statusBarHidden()
                .onAppear(perform: configNav)
                .onChange(of: appViewModel.color) { _ in configNav() }
                .onChange(of: colorScheme) { _ in configNav() }
                .accentColor(Color(appViewModel.color))
                .edgesIgnoringSafeArea(.all)
        }
    }
    
    func configNav() {
        let color = (appViewModel.color == UIColor.black && colorScheme == .dark) ? UIColor.white : appViewModel.color
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: color]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: color]
    }
}




