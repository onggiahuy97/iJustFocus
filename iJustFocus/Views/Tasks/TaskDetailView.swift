//
//  TaskDetailView.swift
//  iJustFocus
//
//  Created by Huy Ong on 3/10/23.
//

import SwiftUI

struct TaskDetailView: View {
  @EnvironmentObject var dataController: DataController
  
  @ObservedObject var task: Tasking
  
  init(task: Tasking) {
    self.task = task
    note = task.note ?? ""
  }
  
  @State private var note: String
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        Text(task.unwrappedName)
          .font(.system(.title3, design: .rounded, weight: .bold))
        TextField("Note", text: $note, axis: .vertical)
      }
      .padding()
    }
    .navigationBarTitleDisplayMode(.inline)
    .onDisappear {
      task.note = note
      dataController.save()
    }
  }
}
