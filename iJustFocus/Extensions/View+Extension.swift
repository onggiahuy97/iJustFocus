//
//  View+Extension.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/25/22.
//

import SwiftUI

extension View {
    @ViewBuilder
    func CircleButton(_ text: String, _ backgroundColor: UIColor, action: @escaping (() -> Void)) -> some View{
        Button(action: action) {
            Text(text)
                .padding(10)
                .bold()
                .foregroundColor(.white)
            //                .background(Color((foregroundColor != nil) ? foregroundColor! : appViewModel.color))
                .background(Color(backgroundColor))
                .cornerRadius(10)
                .shadow(radius: 2, x: 0, y: 2)
        }
    }
    
    @ViewBuilder
    func SystemImageButton(_ systemName: String,_ backgroundColor: UIColor, action: @escaping (() -> Void)) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .imageScale(.large)
                .padding(10)
                .foregroundColor(.white)
                .background(Color(backgroundColor))
                .cornerRadius(.infinity)
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
