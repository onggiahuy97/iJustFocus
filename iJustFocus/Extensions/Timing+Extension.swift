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
            timing.date = Date.randomBetween(start: Date(), end: Date().addingTimeInterval(86400*7))
            timings.append(timing)
        }
        
        try? viewContext.save()
        
        return timings
    }
    
    static func createSample(dataController: DataController) {
        let viewContext = dataController.container.viewContext
        
        var timings = [Timing]()
        
        for _ in 0..<5 {
            let timing = Timing(context: viewContext)
            timing.second = Int64(Int.random(in: 300...30000))
            timing.date = Date.randomBetween(start: Date(), end: Date().addingTimeInterval(86400*7))
            timings.append(timing)
        }
        
        try? viewContext.save()
    }
}
