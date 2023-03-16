//
//  HapticFeedBack.swift
//  iJustFocus
//
//  Created by Huy Ong on 3/13/23.
//

import SwiftUI

extension View {
  func generateFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
    UIImpactFeedbackGenerator(style: style).impactOccurred()
  }
}
