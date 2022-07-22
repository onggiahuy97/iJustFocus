//
//  AppViewModel.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/19/22.
//

import SwiftUI

class AppViewModel: ObservableObject {
    @Published var linearGradient = LinearGradient(colors: [.blue.opacity(0.75), .blue.opacity(0.85)], startPoint: .topLeading, endPoint: .bottomTrailing)
    
    @Published var color: UIColor = .systemBlue {
        didSet {
            let colors = [color.withAlphaComponent(0.75), color.withAlphaComponent(0.85)].map { Color(uiColor: $0) }
            linearGradient = LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
            boolCheck.toggle()
        }
    }
    
    var boolCheck: Bool = false
    
    var colors: [Coloring] = AppViewModel.sampleColors
    
    struct Coloring: Identifiable {
        var id = UUID()
        var text: String
        var uiColor: UIColor
    }
}

extension AppViewModel {
    static let sampleColors: [Coloring] = [
        .init(text: "Red", uiColor: .systemRed),
        .init(text: "Pink", uiColor: .systemPink),
        .init(text: "Blue", uiColor: .systemBlue),
        .init(text: "Cyan", uiColor: .systemCyan),
        .init(text: "Teal", uiColor: .systemTeal),
        .init(text: "Mint", uiColor: .systemMint),
        .init(text: "Orange", uiColor: .systemOrange),
        .init(text: "Yellow", uiColor: .systemYellow),
        .init(text: "Brown", uiColor: .systemBrown),
        .init(text: "Gray", uiColor: .systemGray),
        .init(text: "Purple", uiColor: .systemPurple),
        .init(text: "System Black", uiColor: .black)
    ]
}
