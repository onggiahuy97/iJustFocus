//
//  ShowGestureGuideView.swift
//  iJustFocus
//
//  Created by Huy Ong on 8/22/22.
//

import SwiftUI

struct ShowGestureGuideView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @Environment(\.dismiss) private var dismiss
        
    var body: some View {
        NavigationStack {
            List {
                if appViewModel.isVertical {
                    Label("Swipe Down For Full Screen Timer", systemImage: "arrow.down")
                    Label("Swipe Up For Full Screen Tasks", systemImage: "arrow.up")
                    Label("Zoom In/Out For Default Screen", systemImage: "arrow.up.left.and.down.right.magnifyingglass")
                } else {
                    Label("Swipe Left For Full Screen Timer", systemImage: "arrow.left")
                    Label("Swipe Right For Full Screen Tasks", systemImage: "arrow.right")
                    Label("Zoom In/Out For Default Screen", systemImage: "arrow.up.left.and.down.right.magnifyingglass")
                }
            }
            .navigationTitle("Gesture")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { dismiss.callAsFunction() }
                }
            }
        }
    }
}

struct ShowGestureGuideView_Previews: PreviewProvider {
    static var previews: some View {
        ShowGestureGuideView()
    }
}

