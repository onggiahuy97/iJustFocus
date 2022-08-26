//
//  ShowGestureGuideView.swift
//  iJustFocus
//
//  Created by Huy Ong on 8/22/22.
//

import SwiftUI

struct ShowGestureGuideView: View {
    @EnvironmentObject var appViewModel: AppViewModel
//
//    var verticalGuide: some View {
//        VStack {
//
//        }
//    }
//
//    var horizontalGuide: some View {
//
//    }
    
    var body: some View {
        ScrollView {
            if appViewModel.isVertical {
                
            } else {
                
            }
        }
    }
}

struct ShowGestureGuideView_Previews: PreviewProvider {
    static var previews: some View {
        ShowGestureGuideView()
    }
}
