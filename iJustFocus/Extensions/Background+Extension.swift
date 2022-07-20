//
//  Background+Extension.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/5/22.
//

import Foundation
import SwiftUI

extension View {
    
    @ViewBuilder
    func defaultBackground() -> some View {
        self
            .edgesIgnoringSafeArea(.all)
            .background(
                Color.blue.opacity(0.3)
            )
    }
}
