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
    
    @State private var viewType = ViewType.Chart
    
    enum ViewType {
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
                switch viewType {
                case .List: gridView
                case .Chart: HistoryBarChart()
                }
            }
            .navigationTitle(Text("History"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Picker("Picker", selection: $viewType) {
                        Text("List").tag(ViewType.List)
                        Text("Chart").tag(ViewType.Chart)
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


