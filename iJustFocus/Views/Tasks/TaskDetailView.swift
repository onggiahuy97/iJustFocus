//
//  TaskDetailView.swift
//  iJustFocus
//
//  Created by Huy Ong on 3/10/23.
//

import SwiftUI

struct TaskDetailView: View {
  @EnvironmentObject var dataController: DataController
  @EnvironmentObject var appViewMode: AppViewModel
  @Environment(\.dismiss) private var dismiss
  
  @ObservedObject var task: Tasking
  
  @State private var note: String = ""
  @State private var taskName: String = ""
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 12) {
        HStack {
          Button {
            task.isDone.toggle()
          } label: {
            Image(systemName: task.isDone ? "square.fill" : "square")
          }
          Spacer()
          Button("Date & Repeat") {
            
          }
          .foregroundColor(.secondary)
          .font(.callout)
          Spacer()
          Button {
            
          } label: {
            Image(systemName: "flag")
          }
        }
        TextField("Name", text: $taskName)
          .font(.system(.title3, design: .rounded, weight: .bold))
        TextField("Note", text: $note, axis: .vertical)
      }
      .padding()

    }
    .navigationBarTitleDisplayMode(.inline)
    .scrollDismissesKeyboard(.immediately)
    .toolbar {
      ToolbarItem {
        Menu {
          Button(role: .destructive) {
            dataController.delete(task)
            dataController.save()
            dismiss()
          } label: {
            Label("Delete Task", systemImage: "trash")
          }
        } label: {
          Image(systemName: "ellipsis")
        }
      }
    }
    .onAppear {
      note = task.note ?? ""
      taskName = task.unwrappedName
    }
    .onDisappear {
      task.name = taskName.isEmpty ? task.unwrappedName : taskName
      task.note = note
      dataController.save()
    }
  }
}
