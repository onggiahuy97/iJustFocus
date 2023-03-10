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
  @State private var showCompleted = false
  
  var body: some View {
    NavigationStack {
      ScrollView {
        ScrollViewReader { scrollProxy in
          VStack(alignment: .leading, spacing: 12) {
            
            ForEach(tasksViewModel.todoTasks, content: taskView(_:))
              .onDelete(perform: tasksViewModel.deleteTask(_:))
            
            Label {
              VStack {
                TextField("New Task", text: $taskName)
                  .onSubmit {
                    guard !taskName.isEmpty else { return }
                    tasksViewModel.addTask(taskName)
                    taskName = ""
                  }
              }
            } icon: {
              Image(systemName: "pencil")
                .foregroundColor(Color(appViewModel.color))
            }
            
            
            VStack(spacing: 10) {
              HStack {
                Text("COMPLETED")
                Spacer()
                Text("\(tasksViewModel.doneTasks.count)")
                  .foregroundColor(.secondary)
                Image(systemName: "chevron.down")
                  .imageScale(.small)
                  .rotationEffect(Angle(degrees: showCompleted ? 0 : -90))
              }
              .onTapGesture {
                self.showCompleted.toggle()
              }
              .foregroundColor(Color(appViewModel.color))
              if showCompleted {
                ForEach(tasksViewModel.doneTasks, content: taskView(_:))
                  .onDelete(perform: tasksViewModel.deleteTask(_:))
              }
            }
            
          }
          .padding()
          .frame(maxHeight: .infinity)
        }
      }
      .navigationTitle("Tasks")
      .scrollDismissesKeyboard(.immediately)
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
    VStack(alignment: .leading) {
      HStack(alignment: .center) {
        Button {
          task.isDone.toggle()
          dataController.save()
        } label: {
          Image(systemName: task.isDone ? "checkmark.square.fill" : "square")
        }
        NavigationLink {
          TaskDetailView(task: task)
        } label: {
          HStack {
            Text(task.unwrappedName)
              .lineLimit(1)
              .truncationMode(.tail)
              .foregroundColor(Color(uiColor: .label))
            Spacer()
          }
        }
      }
      Divider()
    }
    .foregroundColor(task.isDone ? .secondary : .accentColor)
    .opacity(task.isDone ? 0.5 : 1.0)
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
