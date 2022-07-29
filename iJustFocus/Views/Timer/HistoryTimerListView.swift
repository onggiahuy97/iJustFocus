//
//  TimersListView.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/19/22.
//

import SwiftUI

struct HistoryTimerListView: View {
    @EnvironmentObject var timerViewModel: TimerViewModel
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State private var showBarChart = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($timerViewModel.timingGroup) { timing in
                    DisclosureGroup(isExpanded: timing.isExpanded) {
                        TimingCellView(timing: timing.wrappedValue)
                    } label: {
                        Text(timing.wrappedValue.date.toDayMonthYearString())
                    }
                }
                .onDelete(perform: timerViewModel.deleteTiming(_:))
            }
            .navigationTitle(Text("History"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showBarChart.toggle()
                    } label: {
                        Image(systemName: "chart.bar.xaxis")
                    }
                    .sheet(isPresented: $showBarChart) {
                        HistoryBarChart()
                    }
                }
            }
        }
    }
}

extension HistoryTimerListView {
    static let tag: String? = "TimersListView"
}


