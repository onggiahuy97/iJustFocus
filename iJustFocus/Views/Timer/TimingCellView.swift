//
//  TimingCellView.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/20/22.
//

import SwiftUI

struct TimingCellView: View {
    var timing: Timing
    
    var toDetailTimeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        let startTime = formatter.string(from: timing.unwrappedDate.addingTimeInterval(-Double(timing.second)))
        let endTime = formatter.string(from: timing.unwrappedDate)
        return "\(startTime) to \(endTime)"
    }
    
    var body: some View {
        HStack {
            Text(timing.toString)
            Spacer()
            Text(toDetailTimeString)
                .foregroundColor(.secondary)
                .font(.caption)
        }
    }
}
