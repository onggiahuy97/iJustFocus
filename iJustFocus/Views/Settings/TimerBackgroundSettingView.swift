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
        Form {
            Section("Choose Option") {
                VStack {
                    Button {
                        appViewModel.isShowingTimerBackground = true
                    } label: {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("No Image")
                                Spacer()
                                Image(systemName: "checkmark")
                                    .opacity(appViewModel.isShowingTimerBackground ? 1 : 0)
                            }
                            Image(uiImage: appViewModel.backgroundImage ?? UIImage(named: "placeholder")!)
                                .resizable()
                                .cornerRadius(12)
                                .scaledToFit()
                            Spacer()
                        }
                    }
                    .padding([.top, .leading, .trailing])
                    
                    CircleButton("Pick Image", appViewModel.color) {
                        showPickingImage.toggle()
                    }
                    .sheet(isPresented: $showPickingImage) {
                        ImagePickerView(image: $appViewModel.backgroundImage)
                    }
                }
                .padding(.bottom)
                
                Button {
                    appViewModel.isShowingTimerBackground = false
                } label: {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("No Image")
                            Spacer()
                            Image(systemName: "checkmark")
                                .opacity(appViewModel.isShowingTimerBackground ? 0 : 1)
                        }
                        Image("placeholder")
                            .resizable()
                            .cornerRadius(12)
                            .scaledToFit()
                            .opacity(0)
                            .overlay(
                                Rectangle()
                                    .fill(Color(appViewModel.color))
                                    .cornerRadius(12)
                            )
                        Spacer()
                    }
                }
                .padding()
                
            }
            .buttonStyle(.plain)
            .bold()
            .navigationTitle("Background")
        }
    }
}
