//
//  ConditionData.swift
//  franklin
//
//  Created by Denis Ronchese on 19/04/24.
//

// ConditionData.swift

import Foundation
import MapKit

protocol ConditionData: Identifiable {
    var id: UUID { get }
    var description: String { get }
}

struct TimeConditionData: ConditionData {
    var id: UUID
    var startTime: Date
    var endTime: Date
    var selectedDays: [Bool]
    var selectedDaysDescription: String

    var description: String {
        return "Time from \(startTime) to \(endTime)"
    }
}

struct LocationConditionData: ConditionData {
    var id: UUID
    var location: MKMapItem
    var radius: CGFloat

    var description: String {
        return "Location: \(location.placemark.title ?? "Posto strano")"
    }
}
