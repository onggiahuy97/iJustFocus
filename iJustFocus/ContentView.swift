//
//  ContentView.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/5/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height
            let isVertical = width < height
            
            let timerView = TimerView()
            let homeView = HomeView()
        
            if isVertical {
                VStack(spacing: 0) {
                    timerView
                        .frame(height: height / 2)
                    homeView
                        .frame(height: height / 2)
                }
                .frame(width: width, height: height)
            } else {
                HStack(spacing: 0) {
                    homeView
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
