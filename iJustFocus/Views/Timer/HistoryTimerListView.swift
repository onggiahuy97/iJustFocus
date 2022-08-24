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
    
    @SceneStorage(ViewType.List.rawValue) var selectedViewType = ViewType.List.rawValue
    
    enum ViewType: String {
        case List, Chart
    }
    
    var gridView: some View {
        Grid {
            GridRow {
                Text("Date")
                Text("Focus Times")
                Text("Total Times")
            }
            .bold()
            .foregroundColor(Color(appViewModel.color))
            
            Divider()
            
            ForEach(timerViewModel.timingGroup) { timing in
                GridRow {
                    Text(timing.date.toDayMonthYearString())
                    Text("\(timing.seconds.count)")
                    Text(timing.totalTimes)
                }
                Divider()
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if selectedViewType == ViewType.List.rawValue {
                    gridView
                } else {
                    HistoryBarChart()
                }
            }
            .navigationTitle(Text("History"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Picker("Picker", selection: $selectedViewType) {
                        Text("List").tag(ViewType.List.rawValue)
                        Text("Chart").tag(ViewType.Chart.rawValue)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    .padding(.top, 12)
                }
            }
        }
    }
}

extension HistoryTimerListView {
    static let tag: String? = "TimersListView"
}


