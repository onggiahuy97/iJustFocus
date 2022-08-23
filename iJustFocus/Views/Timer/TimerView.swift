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
    @State private var showSetting = false
    
    var proxy: GeometryProxy
    
    var tupleSize: (CGFloat, CGFloat) {
        let size = proxy.size
        var width: CGFloat = 0
        var height: CGFloat = 0
        if appViewModel.isVertical {
            width = size.width
            height = size.height/2
        } else {
            width = size.width/2
            height = size.height
        }
        
        if appViewModel.currentOrientation == .focusTimer {
            width = size.width
            height = size.height
        }
                
        return (width, height)
    }
    
    var textSize: CGFloat {
        let isPhone = UIDevice.current.userInterfaceIdiom == .phone
        return isPhone ? 800 : 1200
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
    
    var progressGoal: Double {
        let todayTime = timerViewModel.timingGroup.first?.seconds.reduce(0, +) ?? 0
        let goal = appViewModel.goalInMinutes * 60
        let ratio = Double(todayTime) / Double(goal)
        return ratio > 1 ? 1 : ratio
    }
    
    @ViewBuilder
    func timerBackground() -> some View {
        if appViewModel.isShowingTimerBackground {
            Image(uiImage: appViewModel.backgroundImage ?? .init(named: "placeholder")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: tupleSize.0, height: tupleSize.1)
                .clipped()
        } else {
            appViewModel.linearGradient
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Spacer()
                
                // Clock
                Text(clockString)
                    .padding(50)
                    .font(.system(size: textSize, weight: .bold, design: appViewModel.fontDesign?.toFontCase()).monospacedDigit())
                    .foregroundColor(appViewModel.isShowingTimerBackground ? Color(appViewModel.color) : .white)
                    .fontWeight(.bold)
//                    .font(Font(.init(.message, size: 46)))
                    .minimumScaleFactor(0.01)
                
                Spacer()
            }
            // Buttons
            HStack(alignment: .center) {
                MenuButton()
                
                Spacer()
                
                if appViewModel.boolCheck {
                    segmentedController
                } else {
                    segmentedController
                }
                
                
                SystemImageButton("timer", appViewModel.color) {
                    showPickingTime.toggle()
                }
                .opacity(timerViewModel.timeType == .Timer ? 1 : 0)
                .sheet(isPresented: $showPickingTime) {
                    PickingTimeView()
                        .presentationDetents([.medium])
                }
                
                let isStopped = timerViewModel.isStopped
                SystemImageButton(isStopped ? "play.circle" : "pause.circle", appViewModel.color){
                    isStopped ? timerViewModel.start() : timerViewModel.stop()
                }
            }
            .padding()
            
            VStack {
                HStack {
                    SystemImageButton("gear", appViewModel.color) {
                        showSetting.toggle()
                    }
                    .sheet(isPresented: $showSetting) {
                        SettingsView()
                    }
                    .opacity(appViewModel.currentOrientation == .focusTimer ? 1 : 0)
                    Spacer()
                    ProgressView(value: progressGoal)
                        .foregroundColor(Color(appViewModel.color))
                        .frame(width: proxy.size.width * 0.15)
                }
                Spacer()
            }
            .padding()
            
        }
        .background(timerBackground())
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
