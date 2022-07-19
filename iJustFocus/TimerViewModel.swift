//
//  ViewModel.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/5/22.
//

import Foundation
import Combine

class TimerViewModel: ObservableObject {
    @Published var second = TimerViewModel.timerTime
    @Published var timeType = TimeType.Timer
    @Published var isStopped = false

    var timer: Timer?
    
    static let timerTime = 25 * 60
    
    init() { }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        self.isStopped = true
    }
    
    func start() {
        if isStopped {
            reset()
            isStopped = false
        }
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(handleSecond), userInfo: nil, repeats: true)
        }
    }
    
    func reset() {
        second = TimerViewModel.timerTime
    }
    
    @objc
    func handleSecond() {
        DispatchQueue.main.async {
            self.second -= 1
            self.second == 0 ? self.stop() : nil
        }
    }
}

extension TimerViewModel {
    enum TimeType: String, CaseIterable, Identifiable {
        var id: String { self.rawValue }
        
        case Stopwatch, Timer
    }
}
