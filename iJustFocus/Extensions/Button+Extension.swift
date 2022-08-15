//
//  Button+Extension.swift
//  iJustFocus
//
//  Created by Huy Ong on 8/15/22.
//

import SwiftUI

struct ButtonLabelView: View {
    let title: String
    let systemImage: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
        }
    }
}
