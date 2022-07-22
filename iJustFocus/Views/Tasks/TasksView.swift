//
//  TasksView.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/17/22.
//

import SwiftUI

struct TasksView: View {
    @EnvironmentObject var tasksViewModel: TaskViewModel
    @EnvironmentObject var dataController: DataController
    
    @State private var showAddTask = false
    @State private var taskName = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("To-do") {
                    ForEach(tasksViewModel.todoTasks, content: taskView(_:))
                        .onDelete(perform: tasksViewModel.deleteTask(_:))
                }
                Section("Done") {
                    ForEach(tasksViewModel.doneTasks, content: taskView(_:))
                        .onDelete(perform: tasksViewModel.deleteTask(_:))
                }
            }
            .listStyle(.plain)
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddTask.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .alert("Add Task", isPresented: $showAddTask) {
                        addTaskAlert
                    }
                }
            }
        }
    }
    
    var addTaskAlert: some View {
        VStack {
            TextField("Task name", text: $taskName)
            Button("Cancel", role: .cancel) { taskName = "" }
            Button("Add") {
                tasksViewModel.addTask(taskName)
                taskName = ""
            }
        }
    }
    
    func taskView(_ task: Tasking) -> some View {
        Label(task.unwrappedName, systemImage: task.isDone ? "checkmark.circle.fill" : "circle")
            .onTapGesture {
                withAnimation {
                    task.isDone.toggle()
                    dataController.save()
                }
            }
    }
}

extension TasksView {
    static let tag: String? = "TasksView"
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView()
    }
}
