//
//  PickingTimeView.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/23/22.
//

import SwiftUI

struct PickingTimeView: View {
    @EnvironmentObject var timerViewModel: TimerViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        Picker("Timer Picker", selection: $timerViewModel.currentPickedTime) {
            ForEach(TimerViewModel.timingRange) { timing in
                Text("\(timing.minutes) minutes")
                    .foregroundColor(.white)
                    .tag(timing.inSecond)
            }
        }
        .frame(maxHeight: .infinity)
        .foregroundColor(.white)
        .pickerStyle(.wheel)
        .background(appViewModel.linearGradient)
    }
}
