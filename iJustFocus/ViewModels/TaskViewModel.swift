//
//  TaskViewModel.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/17/22.
//

import Foundation
import CoreData

class TaskViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
  private let tasksController: NSFetchedResultsController<Tasking>
  
  var dataController: DataController
  
  @Published var tasks = [Tasking]()
  @Published var justDoneTasks: [Tasking] = []
  
  var pinnedTasks: [Tasking] {
    tasks
      .filter { !$0.isDone && $0.isPinned }
      .sorted { t1, t2 in
        return (t1.createdDate ?? Date()) > (t2.createdDate ?? Date())
      }
  }

  var sortedTasks: [Tasking] {
    tasks
      .filter { !$0.isDone && !$0.isPinned }
      .sorted { t1, t2 in
        return (t1.createdDate ?? Date()) > (t2.createdDate ?? Date())
      }
  }
  
  var doneTasks: [Tasking] {
    tasks
      .filter { $0.isDone }
      .sorted { t1, t2 in
        return (t1.createdDate ?? Date()) > (t2.createdDate ?? Date())
      }
  }
  
  func selectedDateTasks(currentDate: Date) -> [Tasking] {
    return tasks.filter { task in
      guard let remindDate = task.remindDate else { return false }
      return Calendar.current.isDate(remindDate, equalTo: currentDate, toGranularity: .day)
    }
  }

  init(dataController: DataController) {
    self.dataController = dataController
    
    let tasksRequest: NSFetchRequest<Tasking> = Tasking.fetchRequest()
    tasksRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Tasking.name, ascending: true)]
    
    tasksController = NSFetchedResultsController(
      fetchRequest: tasksRequest,
      managedObjectContext: dataController.container.viewContext,
      sectionNameKeyPath: nil,
      cacheName: nil)
    
    super.init()
    
    tasksController.delegate = self
    
    do {
      try tasksController.performFetch()
      tasks = tasksController.fetchedObjects ?? []
    } catch {
      print("Failed to fetch initial tasking data")
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    DispatchQueue.main.async {
      self.tasks = self.tasksController.fetchedObjects ?? []
    }
  }
  
  func addTask(_ name: String, isPinned: Bool = false) {
    guard !name.isEmpty else { return }
    let task = Tasking(context: dataController.container.viewContext)
    task.name = name
    task.createdDate = Date()
    task.isPinned = isPinned
    dataController.save()
  }
  
  func deleteTask(_ indexSet: IndexSet) {
    for offset in indexSet {
      let task = tasks[offset]
      dataController.delete(task)
    }
    
    dataController.save()
  }
  
  func deleteDoneTasks() {
    for task in doneTasks {
      dataController.delete(task)
    }
    dataController.save()
  }
  
  func deleteToDoTasks() {
    for task in sortedTasks {
      dataController.delete(task)
    }
    dataController.save()
  }
  
  func deleteAllTasks() {
    for task in tasks {
      dataController.delete(task)
    }
    dataController.save()
  }
}
