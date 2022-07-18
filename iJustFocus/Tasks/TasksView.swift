//
//  TasksView.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/17/22.
//

import SwiftUI

struct TasksView: View {
    @EnvironmentObject var model: TaskViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section("To-do") {
                    ForEach(model.todoTasks, content: taskView(_:))
                }
                Section("Done") {
                    ForEach(model.doneTasks, content: taskView(_:))
                }
            }
            .listStyle(.plain)
            .navigationTitle("Taks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        model.tasks = TaskViewModel.createSample()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
        }
    }
    
    func taskView(_ task: TaskViewModel.Task) -> some View {
        Label(task.name, systemImage: task.isDone ? "checkmark.circle.fill" : "circle")
            .onTapGesture {
                withAnimation {
                    model.toggleTask(task)
                }
            }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView()
    }
}
