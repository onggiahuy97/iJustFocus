//
//  iJustFocusApp.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/5/22.
//

import SwiftUI

@main
struct iJustFocusApp: App {
    @StateObject var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .persistentSystemOverlays(.hidden)
                .environmentObject(dataController)
                .environment(\.managedObjectContext, DataController.shared.container.viewContext)
        }
    }
}


