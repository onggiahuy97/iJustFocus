//
//  TaskRowView.swift
//  iJustFocus
//
//  Created by Huy Ong on 3/13/23.
//

import SwiftUI

struct TaskRowView: View {
  @EnvironmentObject private var dataController: DataController
  @EnvironmentObject private var tasksViewModel: TaskViewModel
  
  @ObservedObject var task: Tasking
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .center) {
        Button {
          generateFeedback()
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
