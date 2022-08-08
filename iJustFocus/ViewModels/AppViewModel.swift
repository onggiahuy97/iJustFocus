//
//  AppViewModel.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/19/22.
//

import SwiftUI

class AppViewModel: ObservableObject {
    @Published var linearGradient = LinearGradient(
        colors: [.blue.opacity(0.75), .blue.opacity(0.85)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    @Published var color: UIColor = .systemBlue {
        didSet {
            boolCheck.toggle()
            saveColor()
            loadLinearGradient()
        }
    }
    @Published var fontDesign: FontingDesign? {
        didSet {
            setFontDesign()
        }
    }
    @Published var tupleWidthRatio = (0.5, 0.5)
    @Published var currentSizeRation = CurrentSizeRation.mid
    
    var boolCheck: Bool = false
    var isVertical: Bool = false
        
    init() {
        loadMainColor()
        loadFontDesign()
    }
    
    func calculateGestureOnEnded(_ value: DragGesture.Value) {
        let horizontal = value.translation.width
        let vertical = value.translation.height
        
        withAnimation {
            if isVertical {
                // Swipe down
                if vertical > 150 {
                    currentSizeRation = .rightOrDown
                }
                // Swipe up
                else if vertical < -150 {
                    currentSizeRation = .leftOrUp
                }
                // To mid
                else {
                    currentSizeRation = .mid
                }
            } else {
                // Swipe right
                if horizontal > 150 {
                    currentSizeRation = .rightOrDown
                }
                // Swipe left
                else if horizontal < -150 {
                    currentSizeRation = .leftOrUp
                }
                // To the mid
                else {
                    currentSizeRation = .mid
                }
            }
            tupleWidthRatio = currentSizeRation.tupleWithRatio
        }
    }
    
    func calculateGeometryProxy(_ proxy: GeometryProxy) -> CGSize {
        let width = proxy.size.width
        let height = proxy.size.height
        return CGSize(width: width, height: height)
    }
    
    func isVertical(_ proxy: GeometryProxy) -> Bool {
        let width = proxy.size.width
        let height = proxy.size.height
        isVertical = width < height
        return width < height
    }
    
    func loadLinearGradient() {
        let colors = [color.withAlphaComponent(0.75), color.withAlphaComponent(0.85)].map { Color(uiColor: $0) }
        linearGradient = LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
    }
    
    func loadMainColor() {
        let ud = UserDefaults()
        if let color = ud.colorForKey(key: Coloring.forKey) {
            self.color = color
            loadLinearGradient()
        }
    }
    
    func loadFontDesign() {
        if let savedData = UserDefaults.standard.object(forKey: FontingDesign.forKey) as? Data {
            if let fonting = try? JSONDecoder().decode(FontingDesign.self, from: savedData) {
                fontDesign = fonting
            }
        }
    }
    
    func setFontDesign() {
        UserDefaults().setCodableObject(fontDesign, forKey: FontingDesign.forKey)
    }
    
    func saveColor() {
        UserDefaults().setColor(color: color, forKey: Coloring.forKey)
    }
    
   
}

// MARK: - Define Enum
extension AppViewModel {
    enum CurrentSizeRation {
        case leftOrUp, mid, rightOrDown
        var tupleWithRatio: (Double, Double) {
            switch self {
            case .rightOrDown:
                return (0.9, 0.1)
            case .leftOrUp:
                return (0.1, 0.9)
            case .mid:
                return (0.5, 0.5)
            }
        }
    }
}

// MARK: - Define struct
extension AppViewModel {
    struct Coloring: Identifiable {
        var id = UUID()
        var text: String
        var uiColor: UIColor
        
        static let forKey = "Coloring"
    }
    
    
}

// MARK: - Define static variables
extension AppViewModel {
    static let colors: [Coloring] = AppViewModel.sampleColors
    static let sampleColors: [Coloring] = [
        .init(text: "Red", uiColor: .systemRed),
        .init(text: "Pink", uiColor: .systemPink.withAlphaComponent(0.8)),
        .init(text: "Blue", uiColor: .systemBlue),
        .init(text: "Cyan", uiColor: .systemCyan),
        .init(text: "Teal", uiColor: .systemTeal),
        .init(text: "Mint", uiColor: .systemMint),
        .init(text: "Orange", uiColor: .systemOrange.withAlphaComponent(0.8)),
        .init(text: "Yellow", uiColor: .systemYellow.withAlphaComponent(0.8)),
        .init(text: "Brown", uiColor: .systemBrown),
        .init(text: "Gray", uiColor: .systemGray),
        .init(text: "Purple", uiColor: .systemPurple),
        .init(text: "System Black", uiColor: .black)
    ]
}
