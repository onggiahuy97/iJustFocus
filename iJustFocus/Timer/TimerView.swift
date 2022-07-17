//
//  TimerView.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/17/22.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var model: ViewModel
    
    var body: some View {
        ZStack {
            // Segmented Picker
            VStack {
                Picker(selection: $model.timeType) {
                    ForEach(ViewModel.TimeType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                } label: {
                    Text("Time Type")
                }
                .padding()
                .pickerStyle(.segmented)
                .onAppear {
                    UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.secondarySystemGroupedBackground
                    UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
                    UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
                }
                
                Spacer()
            }
            
            VStack {
                // Clock
                Text(model.second.toTimeString)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(Font(.init(.message, size: 46)))
                
                // Buttons
                HStack {
                    if model.timeType == .Timer {
                        
                    } else {
                        
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
