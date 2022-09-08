//
//  ShowGestureGuideView.swift
//  iJustFocus
//
//  Created by Huy Ong on 8/22/22.
//

import SwiftUI

struct ShowGestureGuideView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    private let fraction = 0.3
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                if appViewModel.isVertical {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Swipe Down").font(.headline)
                            
                            TimerView(proxy: proxy).disabled(true)
                                .frame(width: proxy.size.width * fraction, height: proxy.size.height * fraction)
                        }
                        HStack {
                            Text("Swipe Up").font(.headline)
                            TasksView().disabled(true)
                                .frame(width: proxy.size.width * fraction, height: proxy.size.height * fraction)
                        }
                        HStack {
                            Text("Zoom In/Out").font(.headline)
                            ContentView().disabled(true)
                                .frame(width: proxy.size.width * fraction, height: proxy.size.height * fraction)
                        }
                    }
                    .padding()
                } else {
                    VStack {
                        
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct ShowGestureGuideView_Previews: PreviewProvider {
    static var previews: some View {
        ShowGestureGuideView()
    }
}

