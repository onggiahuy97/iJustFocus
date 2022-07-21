//
//  TimersListView.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/19/22.
//

import SwiftUI

struct TimersListView: View {
    @EnvironmentObject var timerViewModel: TimerViewModel
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        NavigationStack {
            List(timerViewModel.timingGroup) { timing in
                Section("\(timing.date.toDayMonthYearString())") {
                    ForEach(timing.seconds, id: \.self) { second in
                        Text("\(second)")
                    }
                }
            }
            .navigationTitle("History")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Sample") {
                        Timing.createSample(dataController: dataController)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Delete All") {
                        timerViewModel.deleteAll()
                    }
                }
            }
        }
    }
}

extension TimersListView {
    static let tag: String? = "TimersListView"
}



struct TimersListView_Previews: PreviewProvider {
    static var previews: some View {
        TimersListView()
    }
}
