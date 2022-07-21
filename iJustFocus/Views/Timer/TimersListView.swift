//
//  TimersListView.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/19/22.
//

import SwiftUI

struct TimersListView: View {
    @EnvironmentObject var timerViewModel: TimerViewModel
    
    var body: some View {
        NavigationStack {
            List(timerViewModel.timingGroup) { timing in
                TimingCellView(timing: timing)
            }
            .navigationTitle("History")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Sample") {
                        Timing.createSample()
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
