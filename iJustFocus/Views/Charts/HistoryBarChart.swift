//
//  HistoryBarChart.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/27/22.
//

import SwiftUI
import Charts

struct HistoryBarChart: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var timerViewModel: TimerViewModel
    
    var body: some View {
        NavigationStack {
            Chart(timerViewModel.timingGroup.prefix(7)) { id in
                BarMark(
                    x: .value("Date", id.date, unit: .day),
                    y: .value("Times", id.seconds.count),
                    width: 15
                )
            }
            .navigationTitle("Chart History")
            .foregroundColor(Color(appViewModel.color))
            .padding()
            .frame(height: 240)
        }
    }
}

struct HistoryBarChart_Previews: PreviewProvider {
    static var previews: some View {
        HistoryBarChart()
    }
}
