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
    
    var timer: Timer?
    
    init() { }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        second = 25 * 60
    }
    
    func start() {
        second = 25 * 60
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(handleSecond), userInfo: nil, repeats: true)
        }
    }
    
    @objc
    func handleSecond() {
        DispatchQueue.main.async {
            self.second -= 1
        }
    }
}

extension TimerViewModel {
    enum TimeType: String, CaseIterable, Identifiable {
        var id: String { self.rawValue }
        
        case Stopwatch, Timer
    }
}
