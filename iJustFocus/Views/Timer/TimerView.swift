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
    
    var textSize: CGFloat {
        let isPhone = UIDevice.current.userInterfaceIdiom == .phone
        return isPhone ? 80 : 120
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
            Text(timerViewModel.second.toTimeString([.minute, .second]))
                .font(.system(size: textSize, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .fontWeight(.bold)
                .font(Font(.init(.message, size: 46)))
            
            Spacer()
            
            // Buttons
            HStack {
                Spacer()
    
                CircleButton("Stop", appViewModel.color){
                    timerViewModel.stop()
                }
                                
                CircleButton(timerViewModel.isStopped ? "Reset" : "Start", appViewModel.color) {
                    timerViewModel.start()
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(appViewModel.linearGradient)
    }
    
    func CircleButton(_ text: String, _ foregroundColor: UIColor = .white ,action: @escaping (() -> Void)) -> some View{
        return Button { action() } label: {
            Text(text)
                .padding(12)
                .bold()
                .foregroundColor(.white)
                .background(Color(foregroundColor))
                .cornerRadius(10)
                .shadow(radius: 2, x: 0, y: 2)
        }
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
