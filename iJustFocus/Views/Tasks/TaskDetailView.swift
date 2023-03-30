//
//  TaskDetailView.swift
//  iJustFocus
//
//  Created by Huy Ong on 3/10/23.
//

import SwiftUI

struct RemindDatePickerView: View {
  
  @Binding var showDatePicker: Bool
  @Binding var selectedDate: Date
  
  let action: (() -> Void)
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Button("Cancel", role: .destructive) {
          showDatePicker = false
        }
        Spacer()
        Button("Save") {
          action()
          showDatePicker = false
        }
      }
      .padding(.horizontal)
      DatePicker("Pick A Date", selection: $selectedDate, displayedComponents: .date)
        .datePickerStyle(.graphical)
        .presentationDetents([.medium, .large])
    }
  }
}

struct TaskDetailView: View {
  @EnvironmentObject var dataController: DataController
  @EnvironmentObject var appViewMode: AppViewModel
  @Environment(\.dismiss) private var dismiss
  
  @ObservedObject var task: Tasking
  
  @State private var note: String = ""
  @State private var taskName: String = ""
  @State private var showDatePicker = false
  @State private var selectedDate = Date()
  
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
            showDatePicker = true
          }
          .foregroundColor(.secondary)
          .font(.callout)
          .sheet(isPresented: $showDatePicker) {
            RemindDatePickerView(showDatePicker: $showDatePicker, selectedDate: $selectedDate) {
              task.remindDate = selectedDate
              dataController.save()
              showDatePicker = false
            }
          }
          
          Spacer()
          
          Button {
            task.isPinned.toggle()
          } label: {
            Image(systemName: task.isPinned ? "flag.fill" : "flag")
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
