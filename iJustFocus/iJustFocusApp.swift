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
//                .gesture(drag)
        }
    }
}


