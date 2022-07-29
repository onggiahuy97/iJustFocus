//
//  TimingCellView.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/20/22.
//

import SwiftUI

struct TimingCellView: View {
    var timing: TimerViewModel.TimingGroup
    
    var body: some View {
        Section("Total of focus times: \(timing.seconds.count)") {
            ForEach(timing.seconds, id: \.self) { second in
                Text(second.toTimeString)
            }
        }
    }
}

