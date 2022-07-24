//
//  PickingTimeView.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/23/22.
//

import SwiftUI

struct PickingTimeView: View {
    @EnvironmentObject var timerViewModel: TimerViewModel
   
    var body: some View {
        Picker("Timer Picker", selection: $timerViewModel.currentPickedTime) {
            ForEach(TimerViewModel.timingRange) { timing in
                Text("\(timing.minutes) minutes")
                    .tag(timing.inSecond)
            }
        }
        .pickerStyle(.wheel)
    }
}

struct PickingTimeView_Previews: PreviewProvider {
    static var previews: some View {
        PickingTimeView()
    }
}
