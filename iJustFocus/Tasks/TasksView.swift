//
//  TasksView.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/17/22.
//

import SwiftUI

struct TasksView: View {
    @EnvironmentObject var model: TaskViewModel
    
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
            .navigationTitle("Taks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddTask.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .foregroundColor(.black)
                    .alert("Add Task", isPresented: $showAddTask) {
                        addTaskAlert
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Button("Segmented Picker") {}
                }
            }
        }
    }
    
    var addTaskAlert: some View {
        VStack {
            TextField("Task name", text: $taskName)
            Button("Cancel", role: .cancel) { taskName = "" }
            Button("Add") {
                model.tasks.append(.init(name: taskName))
                taskName = ""
            }
        }
    }
    
    func deleteTask(_ indexSet: IndexSet) {
        model.tasks.remove(atOffsets: indexSet)
    }
    
    func taskView(_ task: TaskViewModel.Task) -> some View {
        Label(task.name, systemImage: task.isDone ? "checkmark.circle.fill" : "circle")
            .foregroundColor(.black)
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
