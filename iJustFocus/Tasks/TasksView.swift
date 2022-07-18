//
//  TasksView.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/17/22.
//

import SwiftUI

struct TasksView: View {
    @EnvironmentObject var model: TaskViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Section("To-do") {
                    
                }
                Section("Done") {
                    
                }
            }
            .listStyle(.plain)
            .navigationTitle("Taks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView()
    }
}
