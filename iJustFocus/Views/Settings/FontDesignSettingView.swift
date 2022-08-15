//
//  FontSettingView.swift
//  iJustFocus
//
//  Created by Huy Ong on 8/5/22.
//

import SwiftUI

struct FontDesignSettingView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        List(FontingDesign.fontDesigns, rowContent: fontDesignButton(_:))
            .navigationTitle("Font Design")
    }
    
    func fontDesignButton(_ design: FontingDesign) -> some View {
        Button {
            appViewModel.fontDesign = design
        } label: {
            HStack {
                Text(design.name)
                    .font(.system(size: 16, design: design.toFontCase()))
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "checkmark")
                    .opacity(appViewModel.fontDesign?.name == design.name ? 1 : 0)
            }
        }
    }
}

struct FontingDesign: Identifiable, Codable {
    var id = UUID()
    var name: String
    let font: FontCase
    
    enum FontCase: String, Codable {
        case `default`, monospaced, rounded, serif
    }
    
    func toFontCase() -> Font.Design {
        switch self.font {
        case .default: return Font.Design.default
        case .monospaced: return Font.Design.monospaced
        case .rounded: return Font.Design.rounded
        case .serif: return Font.Design.serif
        }
    }
    
    static let forKey: String = "FontingDesign"
    
    static let fontDesigns: [FontingDesign] = [
        .init(name: "Default", font: .default),
        .init(name: "Monospaced", font: .monospaced),
        .init(name: "Rounded", font: .rounded),
        .init(name: "Serif", font: .serif)
    ]
}

struct FontSettingView_Previews: PreviewProvider {
    static var previews: some View {
        FontDesignSettingView()
    }
}
