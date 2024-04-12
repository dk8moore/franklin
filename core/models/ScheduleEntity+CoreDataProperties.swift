//
//  ScheduleEntity+CoreDataProperties.swift
//  franklin
//
//  Created by Denis Ronchese on 23/03/24.
//
//

import Foundation
import CoreData


extension ScheduleEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScheduleEntity> {
        return NSFetchRequest<ScheduleEntity>(entityName: "ScheduleEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var icon: String?
    @NSManaged public var isEnabled: Bool

}

extension ScheduleEntity : Identifiable {

}
