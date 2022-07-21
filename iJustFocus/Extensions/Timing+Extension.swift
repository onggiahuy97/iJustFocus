//
//  Timing+Extension.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/20/22.
//

import Foundation

extension Timing {
    var toString: String {
        Int(self.second).toTimeString
    }
    
    var unwrappedDate: Date {
        self.date ?? Date()
    }
}

extension Timing {
    static var example: [Timing] {
        let viewContext = DataController.shared.container.viewContext
        
        var timings = [Timing]()
        
        for _ in 1...10 {
            let timing = Timing(context: viewContext)
            timing.second = Int64(Int.random(in: 300...3000))
            timing.date = Date.randoomBetween(start: .init(timeIntervalSinceNow: 600000), end: .init())
            timings.append(timing)
        }
        
        try? viewContext.save()
        
        return timings
    }
    
    static func createSample() {
        let viewContext = DataController.shared.container.viewContext
        
        var timings = [Timing]()
        
        for _ in 1...10 {
            let timing = Timing(context: viewContext)
            timing.second = Int64(Int.random(in: 300...3000))
            timing.date = Date.randoomBetween(start: .init(timeIntervalSinceNow: 600000), end: .init())
            timings.append(timing)
        }
        
        try? viewContext.save()
    }
}
