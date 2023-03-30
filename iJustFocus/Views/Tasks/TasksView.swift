//
//  TasksView.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/17/22.
//

import SwiftUI

struct CustomGroup<Content: View>: View {
  @EnvironmentObject var appViewModel: AppViewModel
  
  let title: String
  
  @Binding var isExpanded: Bool
  
  let count: Int
  
  @ViewBuilder
  let content: () -> Content
  
  var body: some View {
    VStack(spacing: 10) {
      HStack {
        Text(title)
        Spacer()
        Text("\(count)")
          .foregroundColor(.secondary)
        Image(systemName: "chevron.down")
          .imageScale(.small)
          .rotationEffect(Angle(degrees: isExpanded ? 0 : -90))
      }
      .font(.headline)
      .onTapGesture {
        self.isExpanded.toggle()
      }
      .foregroundColor(Color(appViewModel.color))
      
      if isExpanded {
        content()
      }
    }
  }
}

struct TasksView: View {
  
  @EnvironmentObject var tasksViewModel: TaskViewModel
  @EnvironmentObject var dataController: DataController
  @EnvironmentObject var appViewModel: AppViewModel
  
  @State private var showCompleted = false
  @State private var showImportant = true
  @State private var showTodo = true
  
  @FocusState private var focusKeyboard: Bool
  
  private var taskTime: DispatchWorkItem?
  
  var body: some View {
    NavigationStack {
      ScrollViewReader { scrollProxy in
        ScrollView {
          VStack(alignment: .leading, spacing: 12) {
            
            if !tasksViewModel.pinnedTasks.isEmpty {
              CustomGroup(title: "IMPORTANT", isExpanded: $showImportant, count: tasksViewModel.pinnedTasks.count) {
                ForEach(tasksViewModel.pinnedTasks, content: TaskRowView.init)
              }
            }
            
            CustomGroup(title: "TO-DO", isExpanded: $showTodo, count: tasksViewModel.sortedTasks.count) {
              ForEach(tasksViewModel.sortedTasks, content: TaskRowView.init)
              ForEach(tasksViewModel.justDoneTasks.filter { !$0.isPinned }, content: TaskRowView.init)
                .onChange(of: tasksViewModel.justDoneTasks) { newValue in
                  DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    newValue.forEach { task in
                      self.tasksViewModel.justDoneTasks.removeAll(where: { $0 == task })
                    }
                  }
                }
            }
            
            CustomGroup(title: "COMPLETED", isExpanded: $showCompleted, count: tasksViewModel.doneTasks.count) {
              ForEach(tasksViewModel.doneTasks, content: TaskRowView.init)
            }
            
//            VStack(spacing: 10) {
//              HStack {
//                Text("COMPLETED")
//                Spacer()
//                Text("\(tasksViewModel.doneTasks.count)")
//                  .foregroundColor(.secondary)
//                Image(systemName: "chevron.down")
//                  .imageScale(.small)
//                  .rotationEffect(Angle(degrees: showCompleted ? 0 : -90))
//              }
//              .font(.headline)
//              .onTapGesture {
//                self.showCompleted.toggle()
//              }
//              .foregroundColor(Color(appViewModel.color))
//
//              if showCompleted {
//                ForEach(tasksViewModel.doneTasks, content: TaskRowView.init)
//                  .onDelete(perform: tasksViewModel.deleteTask(_:))
//              }
//            }
          }
          .padding()
        }
        .overlay(
          AddTaskButton()
        )
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
}

extension TasksView {
  static let tag: String? = "TasksView"
}

struct TasksView_Previews: PreviewProvider {
  static var previews: some View {
    TasksView()
  }
}
