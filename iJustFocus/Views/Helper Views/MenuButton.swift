//
//  MenuButton.swift
//  iJustFocus
//
//  Created by Huy Ong on 8/18/22.
//

import SwiftUI

struct MenuButton: View {
    var isCustomziedCircle: Bool
    
    init(_ isCustomziedCircle: Bool = true) {
        self.isCustomziedCircle = isCustomziedCircle
    }
    
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        Menu {
            ButtonLabelView(title: "Half Half", systemImage: "rectangle.leadinghalf.inset.filled") {
                withAnimation { appViewModel.currentOrientation = .halfHalf }
            }
            ButtonLabelView(title: "Timer", systemImage: "timer") {
                withAnimation { appViewModel.currentOrientation = .focusTimer }
            }
            ButtonLabelView(title: "Tasks", systemImage: "list.bullet") {
                withAnimation { appViewModel.currentOrientation = .focusTodos }
            }
        } label: {
            if isCustomziedCircle {
                SystemImageButton("list.number", appViewModel.color) {}
            } else {
                Text("Menu")
                    .bold()
            }
        }
    }
}
