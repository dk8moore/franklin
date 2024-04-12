//
//  ScheduleManager.swift
//  franklin
//
//  Created by Denis Ronchese on 23/03/24.
//

import Foundation
import CoreData


class ScheduleManager: ObservableObject {
    private var managedObjectContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
    }
    
    func addSchedule(title: String, icon: String, isEnabled: Bool) {
        let newSchedule = ScheduleEntity(context: managedObjectContext)
        newSchedule.id = UUID()
        newSchedule.title = title
        newSchedule.icon = icon
        newSchedule.isEnabled = isEnabled
        saveContext()
    }
    
    func updateScene(schedule: ScheduleEntity, newTitle: String, newIcon: String, isEnabled: Bool) {
        schedule.title = newTitle
        schedule.icon = newIcon
        schedule.isEnabled = isEnabled
        saveContext()
    }
    
    func deleteScene(schedule: ScheduleEntity) {
        managedObjectContext.delete(schedule)
        saveContext()
    }
    
    private func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
}


