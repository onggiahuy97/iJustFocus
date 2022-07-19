//
//  ContentView.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/5/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var timerViewModel = TimerViewModel()
    @StateObject var tasksViewModel = TaskViewModel()
    
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height
            let isVertical = width < height
            
            let timerView = TimerView().environmentObject(timerViewModel)
            let tasksView = TasksView().environmentObject(tasksViewModel)
            
            if isVertical {
                VStack(spacing: 0) {
                    timerView
                        .frame(height: height / 2)
                    tasksView
                        .frame(height: height / 2)
                }
                .frame(width: width, height: height)
            } else {
                HStack(spacing: 0) {
                    tasksView
                        .frame(width: width / 2)
                    timerView
                        .frame(width: width / 2)
                }
                .frame(width: width, height: height)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
