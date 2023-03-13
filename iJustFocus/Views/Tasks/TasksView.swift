//
//  TasksView.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/17/22.
//

import SwiftUI

struct TasksView: View {
  struct AlertDetail: Identifiable {
    let name: String
    let error: String
    let id = UUID()
  }
  
  let feedback = UIImpactFeedbackGenerator(style: .medium)
  
  @EnvironmentObject var tasksViewModel: TaskViewModel
  @EnvironmentObject var dataController: DataController
  @EnvironmentObject var appViewModel: AppViewModel
  
  @State private var showAddTask = false
  @State private var taskName = ""
  @State private var showCompleted = false
  @State private var alertDetail: AlertDetail?
  @State private var showAlert = false
  
  @FocusState private var focusKeyboard: Bool
  
  private var taskTime: DispatchWorkItem?
  
  var body: some View {
    NavigationStack {
      ScrollViewReader { scrollProxy in
        ScrollView {
          VStack(alignment: .leading, spacing: 12) {
            
            ForEach(tasksViewModel.sortedTasks, content: taskView(_:))
            
            ForEach(tasksViewModel.justDoneTasks, content: taskView(_:))
              .onChange(of: tasksViewModel.justDoneTasks) { newValue in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                  newValue.forEach { task in
                    self.tasksViewModel.justDoneTasks.removeAll(where: { $0 == task })
                  }
                }
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
              .font(.headline)
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
        }
        .overlay(
          ZStack {
            if showAddTask {
              Color(appViewModel.color)
                .opacity(0.75)
                .onTapGesture {
                  self.showAddTask = false
                  self.focusKeyboard = false
                }
            }
            VStack() {
              Spacer()
              if !showAddTask {
                SystemImageButton("plus", appViewModel.color) {
                  self.feedback.impactOccurred()
                  showAddTask = true
                  focusKeyboard = true
                }
                .padding(5)
              } else {
                VStack(spacing: 12) {
                  Label {
                    VStack {
                      TextField("New Task", text: $taskName)
                        .focused($focusKeyboard)
                    }
                  } icon: {
                    Image(systemName: "pencil")
                      .foregroundColor(Color(appViewModel.color))
                  }
                  HStack {
                    Spacer()
                    Button {
                      guard !taskName.isEmpty else { return }
                      tasksViewModel.addTask(taskName)
                      taskName = ""
                      showAddTask = false
                    } label: {
                      Image(systemName: "paperplane.fill")
                        .rotationEffect(Angle(degrees: 45))
                    }
                  }
                }
                .padding()
                .background(.white)
              }
            }
          }
            .edgesIgnoringSafeArea(.top)
        )
      }
      .navigationTitle("Tasks")
      .scrollDismissesKeyboard(.immediately)
      .onAppear(perform: listenOnAppear)
      .onDisappear(perform: listenOnDisappear)
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
  
  private func listenOnAppear() {
    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
      showAddTask = false
      focusKeyboard = false
    }
  }
  
  private func listenOnDisappear() {
    NotificationCenter.default.removeObserver(self)
  }
  
  func taskView(_ task: Tasking) -> some View {
    VStack(alignment: .leading) {
      HStack(alignment: .center) {
        Button {
          self.feedback.impactOccurred()
          task.isDone.toggle()
          dataController.save()
          if task.isDone {
            tasksViewModel.justDoneTasks.insert(task, at: 0)
          } else {
            tasksViewModel.justDoneTasks.removeAll(where: { $0 == task })
          }
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
