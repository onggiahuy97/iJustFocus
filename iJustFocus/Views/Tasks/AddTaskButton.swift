//
//  AddTaskButton.swift
//  iJustFocus
//
//  Created by Huy Ong on 3/13/23.
//

import SwiftUI

struct AddTaskButton: View {
  
  @EnvironmentObject var appViewModel: AppViewModel
  @EnvironmentObject var tasksViewModel: TaskViewModel
  
  @Environment(\.colorScheme) private var scheme
  
  @State private var showAddTask: Bool = false
  @State private var taskName = ""
  @State private var isPinned = false
  
  @FocusState private var focusKeyboard: Bool
  
  var body: some View {
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
            generateFeedback()
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
                  .onSubmit {
                    generateFeedback()
                    showAddTask = false
                    focusKeyboard = false
                  }
              }
            } icon: {
              Image(systemName: "pencil")
                .foregroundColor(Color(appViewModel.color))
            }
            HStack(spacing: 12) {
              Button {
                
              } label: {
                Image(systemName: "calendar")
              }
              Button {
                
              } label: {
                Image(systemName: "note.text")
              }
              Button {
                isPinned.toggle()
              } label: {
                Image(systemName: isPinned ? "flag.fill" : "flag")
              }
              Spacer()
              Button {
                addNewTask()
              } label: {
                Image(systemName: "paperplane.fill")
                  .rotationEffect(Angle(degrees: 45))
              }
            }
            Color.clear.frame(height: 1)
          }
          .padding()
          .background(scheme == .light ? .white.opacity(0.9) : .black.opacity(0.75))
          .backgroundStyle(.ultraThinMaterial)
          .cornerRadius(12)
          .padding(.bottom, -12)
        }
      }
    }
    .edgesIgnoringSafeArea(.top)
  }
  
  private func addNewTask() {
    guard !taskName.isEmpty else { return }
    tasksViewModel.addTask(taskName, isPinned: isPinned)
    taskName = ""
    generateFeedback()
  }
}
