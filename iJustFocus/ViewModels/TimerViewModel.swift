//
//  ViewModel.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/5/22.
//

import Foundation
import Combine
import CoreData
import SwiftUI

class TimerViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    private let timesController: NSFetchedResultsController<Timing>
    
    var dataController: DataController
    var timer: Timer?
    
    static let timerTimeDefault = 25 * 60
    
    var times = [Timing]() {
        didSet {
            reloadTimingGroup()
        }
    }
    
    @Published var isStopped = false
    @Published var second = TimerViewModel.timerTimeDefault
    @Published var timeType = TimeType.Timer
    @Published var timingGroup = [TimingGroup]()
    
    struct TimingGroup: Identifiable {
        let id = UUID()
        let date: Date
        var seconds: [Int]
    }
    
    func reloadTimingGroup() {
        timingGroup = times.reduce(into: [TimingGroup]()) { res, par in
            if let index = res.firstIndex(where: { Date.compareTwoDate($0.date, par.unwrappedDate)}) {
                res[index].seconds.append(Int(par.second))
            } else {
                res.append(.init(date: par.unwrappedDate, seconds: [Int(par.second)]))
            }
        }
        .sorted(by: { $0.date > $1.date })
    }
    
    init(dataController: DataController) {
        self.dataController = dataController
        
        let timesRequest: NSFetchRequest<Timing> = Timing.fetchRequest()
        timesRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Timing.date, ascending: false)]
        
        timesController = NSFetchedResultsController(
            fetchRequest: timesRequest,
            managedObjectContext: dataController.container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        super.init()
        
        timesController.delegate = self
        
        do {
            try timesController.performFetch()
            times = timesController.fetchedObjects ?? []
            reloadTimingGroup()
        } catch {
            print("Failed to fetch initial timing data")
        }
    }
    
    func stop() {
        if !isStopped && second != TimerViewModel.timerTimeDefault {
            timer?.invalidate()
            timer = nil
            self.isStopped = true
            addTiming(TimerViewModel.timerTimeDefault - second)
        }
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
        withAnimation {
            self.second = TimerViewModel.timerTimeDefault
        }
    }
    @objc
    func handleSecond() {
        DispatchQueue.main.async {
            self.second -= 1
            self.second == 0 ? self.stop() : nil
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        times = timesController.fetchedObjects ?? []
    }
    
    func addTiming(_ second: Int) {
        withAnimation {
            let timing = Timing(context: dataController.container.viewContext)
            timing.second = Int64(second)
            timing.date = Date()
            dataController.save()
        }
    }
    
    func deleteTiming(_ indexSet: IndexSet) {
        withAnimation {
            for offset in indexSet {
                let timing = times[offset]
                dataController.delete(timing)
            }
            
            dataController.save()
        }
    }
    
    func deleteAll() {
        for timing in times {
            dataController.delete(timing)
        }
        dataController.save()
    }
}

extension TimerViewModel {
    enum TimeType: String, CaseIterable, Identifiable {
        var id: String { self.rawValue }
        
        case Stopwatch, Timer
    }
}
