//
//  TasksView.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/17/22.
//

import SwiftUI

struct TasksView: View {
    @EnvironmentObject var model: TaskViewModel
    @EnvironmentObject var dataController: DataController
    
    @State private var showAddTask = false
    @State private var taskName = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("To-do") {
                    ForEach(model.todoTasks, content: taskView(_:))
                        .onDelete(perform: deleteTask(_:))
                }
                Section("Done") {
                    ForEach(model.doneTasks, content: taskView(_:))
                        .onDelete(perform: deleteTask(_:))
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
            .onAppear(perform: setupNav)
        }
    }
    
    var addTaskAlert: some View {
        VStack {
            TextField("Task name", text: $taskName)
            Button("Cancel", role: .cancel) { taskName = "" }
            Button("Add") {
                model.addTask(taskName)
                taskName = ""
            }
        }
    }
    
    func setupNav() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
    }
    
    func deleteTask(_ indexSet: IndexSet) {
        model.deleteTask(indexSet)
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

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView()
    }
}
