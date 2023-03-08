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
  @EnvironmentObject var appViewModel: AppViewModel
  
  @State private var showAddTask = false
  @State private var taskName = ""
  
  var body: some View {
    NavigationStack {
      Form {
        Section("To-do") {
          ForEach(tasksViewModel.todoTasks, content: taskView(_:))
            .onDelete(perform: tasksViewModel.deleteTask(_:))
          
          Label {
            TextField("New Task", text: $taskName, axis: .vertical)
              .lineLimit(5)
              .onSubmit {
                guard !taskName.isEmpty else { return }
                tasksViewModel.addTask(taskName)
                taskName = ""
              }
          } icon: {
            Image(systemName: "pencil")
              .foregroundColor(Color(appViewModel.color))
          }
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
          HStack {
            Menu {
              EditButton()
              Button(action: tasksViewModel.deleteAllTasks) {
                Label {
                  Text("Delete All Tasks")
                } icon: {
                  Image(systemName: "checklist")
                }
              }
              Button(action: tasksViewModel.deleteDoneTasks) {
                Label {
                  Text("Delete All Done Tasks")
                } icon: {
                  Image(systemName: "checkmark.circle.fill")
                }
              }
              Button(action: tasksViewModel.deleteToDoTasks) {
                Label {
                  Text("Delete All To-Do Tasks")
                } icon: {
                  Image(systemName: "circle")
                }
              }
              
              Text("Swipe On Task to Delete")
            } label: {
              Image(systemName: "ellipsis.circle")
            }
          }
        }
      }
    }
  }
  
  func taskView(_ task: Tasking) -> some View {
    Button {
      withAnimation {
        task.isDone.toggle()
        dataController.save()
      }
    } label: {
      Label {
        Text(task.unwrappedName)
          .foregroundColor(Color(uiColor: .label))
      } icon: {
        Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
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
