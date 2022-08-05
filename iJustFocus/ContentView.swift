//
//  ContentView.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/5/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        GeometryReader { proxy in
            
            let timerView = TimerView()
            let homeView = HomeView()
        
            let width = appViewModel.calculateGeometryProxy(proxy).width
            let height = appViewModel.calculateGeometryProxy(proxy).height
            
            if appViewModel.isVertical(proxy) {
                VStack(spacing: 0) {
                    timerView
                        .frame(height: height * appViewModel.tupleWidthRatio.0)
                        .blur(radius: appViewModel.currentSizeRation == .leftOrUp ? 1 : 0)
                    homeView
                        .frame(height: height * appViewModel.tupleWidthRatio.1)
                        .blur(radius: appViewModel.currentSizeRation == .rightOrDown ? 1 : 0)
                }
                .frame(width: width, height: height)
            } else {
                HStack(spacing: 0) {
                    homeView
                        .frame(width: width * appViewModel.tupleWidthRatio.0)
                        .blur(radius: appViewModel.currentSizeRation == .leftOrUp ? 1 : 0)
                    timerView
                        .frame(width: width * appViewModel.tupleWidthRatio.1)
                        .blur(radius: appViewModel.currentSizeRation == .rightOrDown ? 1 : 0)
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
