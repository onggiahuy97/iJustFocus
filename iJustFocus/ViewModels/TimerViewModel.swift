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
    var times = [Timing]() {
        didSet {
            reloadTimingGroup()
        }
    }
   
    @Published var isStopped = false
    @Published var pickedTimer = TimerViewModel.timerTimeDefault
    @Published var timeType = TimeType.Timer
    @Published var timingGroup = [TimingGroup]()
    @Published var currentPickedTime = TimerViewModel.timerTimeDefault {
        didSet {
            UserDefaults.standard.set(currentPickedTime, forKey: "CurrentPickedTime")
            pickedTimer = currentPickedTime
        }
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
        
        let savedTimer = UserDefaults.standard.integer(forKey: "CurrentPickedTime")
        currentPickedTime = savedTimer == 0 ? TimerViewModel.timerTimeDefault : savedTimer
        
        do {
            try timesController.performFetch()
            times = timesController.fetchedObjects ?? []
            reloadTimingGroup()
        } catch {
            print("Failed to fetch initial timing data")
        }
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
    
    func stop() {
        if !isStopped && pickedTimer != currentPickedTime {
            timer?.invalidate()
            timer = nil
            self.isStopped = true
            addTiming(currentPickedTime - pickedTimer)
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
            self.pickedTimer = currentPickedTime
        }
    }
    
    @objc
    func handleSecond() {
        DispatchQueue.main.async {
            self.pickedTimer -= 1
            self.pickedTimer == 0 ? self.stop() : nil
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        times = timesController.fetchedObjects ?? []
    }
    
    func addTiming(_ second: Int) {
        let timing = Timing(context: dataController.container.viewContext)
        timing.second = Int64(second)
        timing.date = Date()
        dataController.save()
    }
    
    func deleteTiming(_ indexSet: IndexSet) {
        for offset in indexSet {
            let timing = times[offset]
            dataController.delete(timing)
        }
        
        dataController.save()
    }
    
    func deleteAll() {
        for timing in times {
            dataController.delete(timing)
        }
        dataController.save()
    }
}

extension TimerViewModel {
    static let timerTimeDefault = 25 * 60
    static let timingRange: [PickedTimer] = [5, 10, 15, 25, 30, 45, 60].map { PickedTimer(minutes: $0) }

    enum TimeType: String, CaseIterable, Identifiable {
        case Stopwatch, Timer
        
        var id: String { rawValue }
    }
    
    struct PickedTimer: Identifiable {
        var id = UUID()
        var minutes: Int
        var inSecond: Int { minutes * 60 }
    }
    
    struct TimingGroup: Identifiable {
        let id = UUID()
        let date: Date
        var seconds: [Int]
    }
}
