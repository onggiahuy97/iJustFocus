//
//  ContentView.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/5/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var tasksViewModel: TaskViewModel
    
    var body: some View {
        GeometryReader { proxy in
            
            let timerView = TimerView(proxy: proxy)
            let homeView = HomeView()
            
            let width = appViewModel.calculateGeometryProxy(proxy).width
            let height = appViewModel.calculateGeometryProxy(proxy).height
            
            switch appViewModel.currentOrientation {
            case .focusTodos:
                homeView
            case .focusTimer:
                timerView
            case .halfHalf:
                if appViewModel.isVertical(proxy) {
                    VStack(spacing: 0) {
                        timerView
                            .frame(height: height * appViewModel.tupleWidthRatio.0)
                        homeView
                            .frame(height: height * appViewModel.tupleWidthRatio.1)
                    }
                    .frame(width: width, height: height)
                } else {
                    HStack(spacing: 0) {
                        homeView
                            .frame(width: width * appViewModel.tupleWidthRatio.0)
                        timerView
                            .frame(width: width * appViewModel.tupleWidthRatio.1)
                    }
                    .frame(width: width, height: height)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
