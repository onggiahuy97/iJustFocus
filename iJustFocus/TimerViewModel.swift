//
//  ViewModel.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/5/22.
//

import Foundation
import Combine
import CoreData

class TimerViewModellll: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    private let timesController: NSFetchedResultsController<Timing>
    
    var dataController: DataController
    
    @Published var times = [Timing]()
    
    init(dataController: DataController) {
        self.dataController = dataController
        
        let timesRequest: NSFetchRequest<Timing> = Timing.fetchRequest()
        timesRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Timing.date, ascending: true)]
        
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
        } catch {
            print("Failed to fetch initial timing data")
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
}

class TimerViewModel: ObservableObject {
    @Published var second = TimerViewModel.timerTime
    @Published var timeType = TimeType.Timer
    @Published var isStopped = false

    var timer: Timer?
    
    static let timerTime = 25 * 60
    
    init() { }
    
    deinit {
        fatalError()
    }
    
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
