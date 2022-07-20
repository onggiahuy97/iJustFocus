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
            List {
                
            }
            .navigationTitle("History")
        }
    }
}

struct TimersListView_Previews: PreviewProvider {
    static var previews: some View {
        TimersListView()
    }
}
