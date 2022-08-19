//
//  TimerBackgroundSettingView.swift
//  iJustFocus
//
//  Created by Huy Ong on 8/18/22.
//

import SwiftUI

struct TimerBackgroundSettingView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State private var showPickingImage = false
    
    var body: some View {
        List {
            checkMarkButton("No Background Image", appViewModel.isShowingTimerBackground ? 0 : 1) {
                appViewModel.isShowingTimerBackground = false
            }
            
            checkMarkButton("Pick Image", appViewModel.isShowingTimerBackground ? 1 : 0) {
                appViewModel.isShowingTimerBackground = true
            }
            
            CircleButton("Pick Image", appViewModel.color) {
                showPickingImage.toggle()
            }
            .sheet(isPresented: $showPickingImage) {
                ImagePickerView(image: $appViewModel.backgroundImage)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .navigationTitle("Background")
    }
    
    func checkMarkButton(_ text: String, _ opacity: Double, action: @escaping (() -> Void)) -> some View {
        Button {
            DispatchQueue.main.async(execute: action)
        } label: {
            HStack {
                Text(text)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "checkmark")
                    .opacity(opacity)
            }
            .buttonStyle(.plain)
            .bold()
        }
    }
}
