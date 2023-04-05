//
//  iJustFocusWidgetExtension.swift
//  iJustFocusWidgetExtension
//
//  Created by Huy Ong on 3/31/23.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData

struct Provider: IntentTimelineProvider {
  
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), name: "Placehoder")
  }
  
  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), name: "Get Snapshot")
    completion(entry)
  }
  
  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.HuyOng")!
    let storeURL = containerURL.appendingPathExtension("Main.sqlite")
    let description = NSPersistentStoreDescription(url: storeURL)
    let container = NSPersistentContainer(name: "Main")
    container.persistentStoreDescriptions = [description]
    container.loadPersistentStores { _, error in
      if let error {
        print("Error: \(error.localizedDescription)")
      }
    }
    let fetchRequest: NSFetchRequest<Tasking> = Tasking.fetchRequest()
    do {
      let tasks = try container.viewContext.fetch(fetchRequest).map { SimpleEntry(date: $0.createdDate ?? Date(), name: $0.name ?? "")}
      let timeline = Timeline(entries: tasks, policy: .never)
      completion(timeline)
    } catch {
      print("Error fetching data: \(error)")
    }
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let name: String
}

struct iJustFocusWidgetExtensionEntryView : View {
  var entry: Provider.Entry
  
  var body: some View {
    Text(entry.name)
  }
}

struct iJustFocusWidgetExtension: Widget {
  let kind: String = "iJustFocusWidgetExtension"
  
  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
      iJustFocusWidgetExtensionEntryView(entry: entry)
    }
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

struct iJustFocusWidgetExtension_Previews: PreviewProvider {
  static var previews: some View {
    iJustFocusWidgetExtensionEntryView(entry: .init(date: Date(), name: "Previews"))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
