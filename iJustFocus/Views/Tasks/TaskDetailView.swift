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
      DatePicker("Pick A Date", selection: $selectedDate, displayedComponents: .date)
        .datePickerStyle(.graphical)
        .presentationDetents([.medium])
    }
    .padding()
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
  
  @State private var regex: NSRegularExpression = {
    let regexPattern = "(https?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?)"
    let regex = try! NSRegularExpression(pattern: regexPattern)
    return regex
  }()
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 12) {
        HStack {
          Button {
            task.isDone.toggle()
          } label: {
            Image(systemName: task.isDone ? "square.fill" : "square")
          }
          
          Button {
            
          } label: {
            Image(systemName: "bell.badge")
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
            
          } label: {
            Image(systemName: "square.and.arrow.up")
          }
          
          Button {
            task.isPinned.toggle()
          } label: {
            Image(systemName: task.isPinned ? "flag.fill" : "flag")
          }
        }
        TextField("Name", text: $taskName)
          .font(.system(.title3, design: .rounded, weight: .bold))
        TextField("Note", text: $note, axis: .vertical)
          .onChange(of: note) { newValue in
            let range = NSRange(newValue.startIndex..<newValue.endIndex, in: newValue)
            if let match = regex.firstMatch(in: newValue, range: range) {
              let urlRange = Range(match.range, in: newValue)!
              let url = newValue[urlRange]
              print("Found url: \(url)")
            } else {
              print("No URL")
            }
          }
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
