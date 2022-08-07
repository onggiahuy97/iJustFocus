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
            appViewModel.fontDesign = design.font
        } label: {
            HStack {
                Text(design.name)
                    .font(.system(size: 16, design: design.font))
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "checkmark")
                    .opacity(appViewModel.fontDesign == design.font ? 1 : 0)
            }
        }
    }
}

struct FontingDesign: Identifiable {
    var id = UUID()
    let name: String
    let font: Font.Design
    
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
