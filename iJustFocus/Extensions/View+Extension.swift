//
//  View+Extension.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/25/22.
//

import SwiftUI

extension View {
    @ViewBuilder
    func CircleButton(_ text: String, _ foregroundColor: UIColor, action: @escaping (() -> Void)) -> some View{
        Button { action() } label: {
            Text(text)
                .padding(12)
                .bold()
                .foregroundColor(.white)
//                .background(Color((foregroundColor != nil) ? foregroundColor! : appViewModel.color))
                .background(Color(foregroundColor))
                .cornerRadius(10)
                .shadow(radius: 2, x: 0, y: 2)
        }
    }
}

struct ItemsToolBar: ToolbarContent {
    let placement: ToolbarItemPlacement
    let action: () -> Void
    let systemImage: String
    let imageColor: UIColor
    
    var body: some ToolbarContent {
        ToolbarItem(placement: placement) {
            Button(action: action) {
                Image(systemName: systemImage)
                    .foregroundColor(Color(imageColor))
            }
        }
    }
}
