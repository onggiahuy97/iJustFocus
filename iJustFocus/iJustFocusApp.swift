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
    
    registerForPushNotification()
  }
  
  var swipeGesture: some Gesture {
    DragGesture()
      .onEnded(appViewModel.calculateGestureOnEnded(_:))
  }
  
  var magnificationGesture: some Gesture {
    MagnificationGesture()
      .onEnded(appViewModel.calculateMagnificationGestureOnEnded(_:))
  }
  
  var body: some Scene {
    WindowGroup {
      appView
        .environmentObject(timerViewModel)
        .environmentObject(tasksViewModel)
        .environmentObject(appViewModel)
        .environmentObject(dataController)
        .environment(\.managedObjectContext, dataController.container.viewContext)
        .statusBarHidden(appViewModel.isStatusBarHidden)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear(perform: configNav)
        .onChange(of: appViewModel.color) { _ in configNav() }
        .onChange(of: colorScheme) { _ in configNav() }
        .accentColor(Color(appViewModel.color))
        .edgesIgnoringSafeArea(.all)
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
  
  @ViewBuilder
  private var appView: some View {
    if UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac {
//      SplitContentView()
      ContentView()
    } else {
      ContentView()
    }
  }
  
  func configNav() {
    let color = (appViewModel.color == UIColor.black && colorScheme == .dark) ? UIColor.white : appViewModel.color
    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: color]
    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: color]
  }
  
  private func registerForPushNotification() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
      guard granted else { return }
      DispatchQueue.main.async {
        UIApplication.shared.registerForRemoteNotifications()
      }
    }
  }
}

class AppDeletegate: NSObject, UIApplicationDelegate, UISceneDelegate, ObservableObject {
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print(deviceToken)
  }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print(error)
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    
  }
  
  func applicationDidFinishLaunching(_ application: UIApplication) {
    print("Did finish launching")
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    print("Hello enter background")
  }
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    #if targetEnvironment(macCatalyst)
    if let titlebar = windowScene.titlebar {
      titlebar.titleVisibility = .hidden
      titlebar.toolbar = nil
    }
    #endif
  }
}

