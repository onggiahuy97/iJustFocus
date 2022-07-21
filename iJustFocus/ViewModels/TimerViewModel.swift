//
//  ViewModel.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/5/22.
//

import Foundation
import Combine
import CoreData

class TimerViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    private let timesController: NSFetchedResultsController<Timing>
    
    var dataController: DataController
    var timer: Timer?
    
    static let timerTimeDefault = 25 * 60
    
    @Published var times = [Timing]() { didSet { reloadTimingGroup() } }
    @Published var isStopped = false
    @Published var second = TimerViewModel.timerTimeDefault
    @Published var timeType = TimeType.Timer
    @Published var timingGroup = [TimingGroup]()
    
    func reloadTimingGroup() {
        for time in times {
            if let index = timingGroup.firstIndex(where: { Date.compareTwoDate($0.date, time.unwrappedDate) }) {
                timingGroup[index].seconds.append(Int(time.second))
            } else {
                timingGroup.append(.init(date: time.unwrappedDate, seconds: [Int(time.second)]))
            }
        }
    }
    
    struct TimingGroup: Identifiable {
        let id = UUID()
        let date: Date
        var seconds: [Int]
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
        timer?.invalidate()
        timer = nil
        self.isStopped = true
        addTiming(TimerViewModel.timerTimeDefault - second)
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
        self.second = TimerViewModel.timerTimeDefault
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
        reloadTimingGroup()
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
        reloadTimingGroup()
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
