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
    
    let numberOfPrefix = 5
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Focus Times")
                    Chart(timerViewModel.timingGroup.prefix(numberOfPrefix)) { id in
                        BarMark(
                            x: .value("Date", id.date, unit: .day),
                            y: .value("Times", id.seconds.count),
                            width: 15
                        )
                    }
                }
                .padding()
                .frame(height: 200)
                
                VStack(alignment: .leading) {
                    Text("Minutes")
                    Chart(timerViewModel.timingGroup.prefix(numberOfPrefix)) { id in
                        BarMark(
                            x: .value("Date", id.date, unit: .day),
                            y: .value("Minutes", id.totalMinute),
                            width: 15
                        )
                    }
                }
                .padding()
                .frame(height: 200)
            }
            .navigationTitle("Chart History")
            .foregroundColor(Color(appViewModel.color))
            .bold()
        }
    }
}

