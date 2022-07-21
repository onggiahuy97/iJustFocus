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
        Section("\(timing.date)") {
            ForEach(timing.seconds, id: \.self) { second in
                Text("\(second)")
            }
        }
    }
}
