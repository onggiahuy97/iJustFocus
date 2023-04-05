//
//  CalendarView.swift
//  iJustFocus
//
//  Created by Huy Ong on 3/13/23.
//

import SwiftUI

struct CalendarView: View {
  static let tag: String? = "CalendarView"
  
  @EnvironmentObject var tasksViewModel: TaskViewModel
  @EnvironmentObject var dataController: DataController
  @EnvironmentObject var appViewModel: AppViewModel
  
  @State private var currentDay = Date()
  @State private var showTodo = true
  
  var body: some View {
    NavigationStack {
      ScrollView {
        WeekRowView(currentDay: $currentDay)
        Divider()
        
        let tasks = tasksViewModel.selectedDateTasks(currentDate: currentDay)
        CustomGroup(title: "TO-DO", isExpanded: $showTodo, count: tasks.count) {
          ForEach(tasks) { task in
            TaskRowView(task: task)
          }
        }
        .padding()
      }
      .navigationTitle("Calendar")
      .toolbar {
        ToolbarItem {
          Button {
            
          } label: {
            Image(systemName: "square.stack")
              .rotationEffect(.init(degrees: 180))
          }
        }
      }
    }
  }
}

struct WeekRowView: View {
  @EnvironmentObject var appVM: AppViewModel
  
  @Binding var currentDay: Date
  
  var body: some View {
    HStack(spacing: 0) {
      ForEach(Calendar.current.currentWeek) { weekday in
        let status = Calendar.current.isDate(weekday.date, inSameDayAs: currentDay)
        VStack(spacing: 6) {
          Text(weekday.string.prefix(3))
            .font(.system(size: 11))
          Text(weekday.date.toString("dd"))
            .font(.system(size: 14))
        }
        .overlay(alignment: .bottom, content: {
          if weekday.isToday {
            Circle()
              .frame(width: 6, height: 6)
              .offset(y: 12)
              .foregroundColor(status ? Color(appVM.color) : .gray)
          }
        })
        .foregroundColor(status ? Color(appVM.color) : .gray)
        .lineLimit(1)
        .frame(maxWidth: .infinity, alignment: .center)
        .onTapGesture {
          withAnimation {
            currentDay = weekday.date
          }
        }
        .padding()
      }
    }
  }
}

//struct WeekRowView: View {
//  @EnvironmentObject var appVM: AppViewModel
//
//  @Binding var currentDay: Date
//
//  let calendar = Calendar.current
//  let weeksToShow = 7
//
//  var body: some View {
//    ScrollView(.horizontal, showsIndicators: false) {
//      HStack(spacing: 0) {
//        ForEach(0..<weeksToShow) { weekIndex in
//          let firstWeekdayOfCurrentWeek = calendar.dateInterval(of: .weekOfMonth, for: currentDay)?.start
//          let weekStartDate = calendar.date(byAdding: .weekOfMonth, value: weekIndex, to: firstWeekdayOfCurrentWeek ?? Date())
//          let week = calendar.weekDays(for: weekStartDate ?? Date())
//
//          ForEach(week) { weekday in
//            let status = calendar.isDate(weekday.date, inSameDayAs: currentDay)
//            VStack(spacing: 6) {
//              Text(weekday.string.prefix(3))
//                .font(.system(size: 11))
//              Text(weekday.date.toString("dd"))
//                .font(.system(size: 14))
//            }
//            .overlay(alignment: .bottom, content: {
//              if weekday.isToday {
//                Circle()
//                  .frame(width: 6, height: 6)
//                  .offset(y: 12)
//                  .foregroundColor(status ? Color(appVM.color) : .gray)
//              }
//            })
//            .foregroundColor(status ? Color(appVM.color) : .gray)
//            .lineLimit(1)
//            .frame(maxWidth: .infinity, alignment: .center)
//            .onTapGesture {
//              withAnimation {
//                currentDay = weekday.date
//              }
//            }
//            .padding()
//          }
//        }
//      }
//    }
//    .frame(height: 60) // set the height of the scroll view
//  }
//}

extension Date {
  func toString(_ format: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: self)
  }
}

extension Calendar {
  func weekDays(for date: Date) -> [WeekDay] {
    let firstWeekDay = self.dateInterval(of: .weekOfMonth, for: date)?.start ?? Date()
    var week: [WeekDay] = []
    for index in 0..<7 {
      if let day = self.date(byAdding: .day, value: index, to: firstWeekDay) {
        let weekDaySymbol: String = day.toString("EEEE")
        let isToday = self.isDateInToday(day)
        week.append(.init(string: weekDaySymbol, date: day, isToday: isToday))
      }
    }
    return week
  }
  
  //  var currentWeek: [WeekDay] {
  //    guard let firstWeekDay = self.dateInterval(of: .weekOfMonth, for: Date())?.start else { return [] }
  //    var week: [WeekDay] = []
  //    for index in 0..<7 {
  //      if let day = self.date(byAdding: .day, value: index, to: firstWeekDay) {
  //        let weekDaySymbol: String = day.toString("EEEE")
  //        let isToday = self.isDateInToday(day)
  //        week.append(.init(string: weekDaySymbol, date: day, isToday: isToday))
  //      }
  //    }
  //    return week
  //  }
  
  var currentWeek: [WeekDay] {
    let today = Date()
    var week: [WeekDay] = []
    for index in 0..<7 {
      if let day = self.date(byAdding: .day, value: index, to: today) {
        let weekDaySymbol: String = day.toString("EEEE")
        let isToday = self.isDateInToday(day)
        week.append(.init(string: weekDaySymbol, date: day, isToday: isToday))
      }
    }
    return week
  }
  
  struct WeekDay: Identifiable {
    var id: UUID = .init()
    var string: String
    var date: Date
    var isToday: Bool = false
  }
}
