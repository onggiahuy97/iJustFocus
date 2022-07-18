//
//  ViewModel.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/5/22.
//

import Foundation
import Combine

class TimerViewModel: ObservableObject {
    @Published var second = 25 * 60
    @Published var timeType = TimeType.Timer
    
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    var cancallables = Set<AnyCancellable>()
    
    init() {
        start()
    }
    
    func stop() {
        
    }
    
    func start() {
        timer
            .sink { _ in
                self.second -= 1
            }
            .store(in: &cancallables)
    }
}

extension TimerViewModel {
    enum TimeType: String, CaseIterable, Identifiable {
        var id: String { self.rawValue }
        
        case Stopwatch, Timer
    }
}
