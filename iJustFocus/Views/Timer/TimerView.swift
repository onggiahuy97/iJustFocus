//
//  TimerView.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/17/22.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var timerViewModel: TimerViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State private var showPickingTime = false
    @State private var showPickingImage = false
    
    var proxy: GeometryProxy
    
    var textSize: CGFloat {
        let isPhone = UIDevice.current.userInterfaceIdiom == .phone
        return isPhone ? 80 : 120
    }
    
    var clockString: String {
        switch timerViewModel.timeType {
        case .Timer: return timerViewModel.pickedTimer.toTimeString
        case .Stopwatch: return timerViewModel.stopWatch.toTimeString
        }
    }
    
    var segmentedController: some View {
        Picker(selection: $timerViewModel.timeType) {
            ForEach(TimerViewModel.TimeType.allCases) { type in
                Text(type.rawValue).tag(type)
            }
        } label: {
            Text("Time Type")
        }
        .padding()
        .pickerStyle(.segmented)
        //            .colorMultiply(Color(appViewModel.color.withAlphaComponent(0.75)))
        .onAppear {
            UISegmentedControl.appearance().selectedSegmentTintColor = appViewModel.color.withAlphaComponent(0.75)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        }
    }
    
    var tabViewBackgroundTimer: some View {
        TabView(selection: $appViewModel.isShowingTimerBackground) {
            Image(uiImage: appViewModel.backgroundImage ?? .init(named: "placeholder")!)
                .resizable()
                .scaledToFit()
                .ignoresSafeArea(.all)
                .cornerRadius(12)
                .padding()
                .opacity(appViewModel.isShowingTimerBackground ? 1 : 0)
                .onTapGesture { showPickingImage.toggle() }
                .sheet(isPresented: $showPickingImage) {
                    ImagePickerView(image: $appViewModel.backgroundImage)
                }
                .tag(true)
            
            Rectangle().fill(.clear).tag(false)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    var body: some View {
        VStack {
#warning("Temperary checking")
            if appViewModel.boolCheck {
                segmentedController
            } else {
                segmentedController
            }
            
            VStack {
                Spacer()
                
                // Clock
                Text(clockString)
                    .font(.system(size: textSize, weight: .bold, design: appViewModel.fontDesign?.toFontCase()).monospacedDigit())
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(Font(.init(.message, size: 46)))
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(tabViewBackgroundTimer)
            
            // Buttons
            HStack {
                MenuButton()
                
                Spacer()
                
                if timerViewModel.timeType == .Timer {
                    SystemImageButton("timer", appViewModel.color) {
                        showPickingTime.toggle()
                    }
                    .sheet(isPresented: $showPickingTime) {
                        PickingTimeView()
                            .presentationDetents([.medium])
                    }
                }
                
                let isStopped = timerViewModel.isStopped
                SystemImageButton(isStopped ? "play.circle" : "pause.circle", appViewModel.color){
                    isStopped ? timerViewModel.start() : timerViewModel.stop()
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(appViewModel.linearGradient)
    }
}

struct SegmentedControllerViewModifier: ViewModifier {
    var color: UIColor
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                UISegmentedControl.appearance().selectedSegmentTintColor = color.withAlphaComponent(0.75)
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
            }
    }
}
