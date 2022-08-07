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
    
    var body: some View {
        VStack {
#warning("Temperary checking")
            if appViewModel.boolCheck {
                segmentedController
            } else {
                segmentedController
            }
            
            Spacer()
            
            // Clock
            Text(clockString)
                .font(.system(size: textSize, weight: .bold, design: appViewModel.fontDesign).monospacedDigit())
                .foregroundColor(.white)
                .fontWeight(.bold)
                .font(Font(.init(.message, size: 46)))
                
            
            Spacer()
            
            // Buttons
            HStack {
                if timerViewModel.timeType == .Timer {
                    CircleButton("Timing", appViewModel.color) {
                        showPickingTime.toggle()
                    }
                    .sheet(isPresented: $showPickingTime) {
                        PickingTimeView()
                            .presentationDetents([.medium])
                    }
                }
                
                Spacer()
                let isStopped = timerViewModel.isStopped
                CircleButton(isStopped ? "Start" : "Stop", appViewModel.color){
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

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
