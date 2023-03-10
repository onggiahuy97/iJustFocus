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
  
  @FocusState private var isTextFieldFocus: Bool
  
  @State private var showAddTask = false
  @State private var taskName = ""
  @State private var showCompleted = false
  
  var body: some View {
    NavigationStack {
      List {
        Section("To-do") {
          ForEach(tasksViewModel.todoTasks, content: taskView(_:))
            .onDelete(perform: tasksViewModel.deleteTask(_:))
          
          Label {
            VStack {
              TextField("New Task", text: $taskName)
                .onSubmit {
                  guard !taskName.isEmpty else { return }
                  tasksViewModel.addTask(taskName)
                  taskName = ""
                  isTextFieldFocus = true
                }
                .focused($isTextFieldFocus)
            }
          } icon: {
            Image(systemName: "pencil")
              .foregroundColor(Color(appViewModel.color))
          }
        }
        
        Section {
          if showCompleted {
            ForEach(tasksViewModel.doneTasks, content: taskView(_:))
              .onDelete(perform: tasksViewModel.deleteTask(_:))
          }
        } header: {
          HStack {
            Text("Completed")
            Spacer()
            Text("\(tasksViewModel.doneTasks.count)")
            Button {
              self.showCompleted.toggle()
            } label: {
              Image(systemName: "chevron.down")
                .imageScale(.small)
                .rotationEffect(Angle(degrees: showCompleted ? 0 : -90))
            }
          }
        }
      }
      .navigationTitle("Tasks")
      .scrollDismissesKeyboard(.immediately)
      .animation(.default, value: showCompleted)
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
        Image(systemName: task.isDone ? "checkmark.square.fill" : "square")
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
