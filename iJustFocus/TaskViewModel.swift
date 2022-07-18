//
//  TaskViewModel.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/17/22.
//

import Foundation
 
class TaskViewModel: ObservableObject {
    @Published var tasks = [Task]()
    
    var todoTasks: [Task] {
        tasks.filter { !$0.isDone }.sorted(by: { $0.name < $1.name })
    }
    
    var doneTasks: [Task] {
        tasks.filter { $0.isDone }
    }
    
    struct Task: Identifiable {
        var id = UUID()
        var name: String
        var isDone = false
    }
    
    func toggleTask(_ task: TaskViewModel.Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isDone.toggle()
        }
    }
}

extension TaskViewModel {
    static func createSample() -> [Task] {
        return (0..<10).map { Task(name: "Task \($0)", isDone: Bool.random()) }
    }
}
