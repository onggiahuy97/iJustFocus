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
    @Environment(\.scenePhase) private var scenePhase
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDeletegate
    
    init() {
        let dataController = DataController()
        _appViewModel = StateObject(wrappedValue: .init())
        _dataController = StateObject(wrappedValue: dataController)
        _timerViewModel = StateObject(wrappedValue: .init(dataController: dataController))
        _tasksViewModel = StateObject(wrappedValue: .init(dataController: dataController))
        
        // Turn of auto turn off / dim screen
        UIApplication.shared.isIdleTimerDisabled = true
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
                .gesture(drag)
                .persistentSystemOverlays(.hidden)
                .onChange(of: scenePhase) { newSP in
                    switch newSP {
                    case .active:
                        print("active")
                    case .background:
                        print("background")
                    case .inactive:
                        print("inactive")
                    @unknown default:
                        print("defualt unknown")
                    }
                }
        }
    }
    
    func configNav() {
        let color = (appViewModel.color == UIColor.black && colorScheme == .dark) ? UIColor.white : appViewModel.color
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: color]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: color]
    }
}

class AppDeletegate: NSObject, UIApplicationDelegate, ObservableObject {
    func applicationDidFinishLaunching(_ application: UIApplication) {
        print("Did finish launching")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Hello enter background")
    }
}

