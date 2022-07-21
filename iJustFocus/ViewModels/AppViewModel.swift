//
//  AppViewModel.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/19/22.
//

import Foundation

class AppViewModel: ObservableObject {
    @Published var selectedHomeViewItem = HomeViewItem.Tasks
    enum HomeViewItem: String, CaseIterable {
        case Tasks, Timers
    }
    
}
