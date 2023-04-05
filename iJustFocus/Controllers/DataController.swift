//
//  DataController.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/19/22.
//

import Foundation
import CoreData
import CloudKit

class DataController: ObservableObject {
  
  static let shared = DataController()
  
  let container: NSPersistentCloudKitContainer
  
  init(inMemory: Bool = false) {
    container = NSPersistentCloudKitContainer(name: "Main")
    
    if inMemory {
      container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
    } else {
    }
    
    if let description = container.persistentStoreDescriptions.first {
      description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
      description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
    }
    
    container.viewContext.automaticallyMergesChangesFromParent = true
    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

    
    container.loadPersistentStores { _, error in
      if let error = error {
        fatalError("Fatal error loading store: \(error.localizedDescription)")
      }
      
      self.container.viewContext.automaticallyMergesChangesFromParent = true
    }
  }
  
  func save() {
    if container.viewContext.hasChanges {
      try? container.viewContext.save()
    }
  }
  
  func delete(_ object: NSManagedObject) {
    container.viewContext.delete(object)
  }
}

