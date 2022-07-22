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
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(timerViewModel.timingGroup) { timing in
                    TimingCellView(timing: timing)
                }
                .onDelete(perform: timerViewModel.deleteTiming(_:))
            }
            .navigationTitle(Text("History"))
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Add Sample") {
//                        Timing.createSample(dataController: dataController)
//                    }
//                }
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Delete All") {
//                        timerViewModel.deleteAll()
//                    }
//                }
//            }
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
