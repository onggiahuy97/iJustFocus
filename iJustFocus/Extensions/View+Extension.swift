//
//  View+Extension.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/25/22.
//

import SwiftUI

extension View {
    @ViewBuilder
    func CircleButton(_ text: String, _ foregroundColor: UIColor,action: @escaping (() -> Void)) -> some View{
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
