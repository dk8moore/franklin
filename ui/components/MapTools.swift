//
//  MapTools.swift
//  franklin
//
//  Created by Denis Ronchese on 11/04/24.
//

import UIKit
import MapKit

func iconForMapItem(_ mapItem: MKMapItem) -> String {
    guard let category = mapItem.pointOfInterestCategory else {
        return "mappin.circle.fill"
    }
    
    switch category {
        case .airport:
            return "airplane.circle.fill"
        case .amusementPark: // NOT CORRECT => PANORAMIC WHEEL
            return "face.smiling.fill"
        case .aquarium: // NOT CORRECT => DOLPHIN
            return "drop.circle.fill"
        case .atm: // NOT CORRECT => CREDIT CARD ENTERING THE LID
            return "creditcard.circle.fill"
        case .bakery: // NOT CORRECT => CROISSANT
            return "leaf.circle.fill"
        case .bank:
            return "building.columns.circle.fill"
        case .beach:
            return "sun.max.circle.fill"
        case .brewery:
            return "cup.and.saucer.fill"
        case .cafe:
            return "cup.and.saucer.fill"
        case .campground:
            return "leaf.arrow.circlepath.circle.fill"
        case .carRental:
            return "car.circle.fill"
        case .evCharger:
            return "bolt.car.circle.fill"
        case .fireStation:
            return "flame.circle.fill"
        case .fitnessCenter:
            return "figure.walk.circle.fill"
        case .foodMarket:
            return "cart.fill"
        case .gasStation:
            return "fuelpump.circle.fill"
        case .hospital:
            return "cross.circle.fill"
        case .hotel:
            return "bed.double.circle.fill"
        case .laundry:
            return "bubble.right.circle.fill"
        case .library:
            return "books.vertical.circle.fill"
        case .marina:
            return "sailboat.circle.fill"
        case .movieTheater:
            return "film.circle.fill"
        case .museum:
            return "paintpalette.circle.fill"
        case .nationalPark:
            return "leaf.arrow.circlepath.circle.fill"
        case .nightlife:
            return "moon.stars.circle.fill"
        case .park:
            return "parkingsign.circle.fill"
        case .parking:
            return "car.circle.fill"
        case .pharmacy:
            return "cross.vial.circle.fill"
        case .police:
            return "shield.lefthalf.fill"
        case .postOffice:
            return "envelope.circle.fill"
        case .publicTransport:
            return "bus.circle.fill"
        case .restaurant:
            return "fork.knife.circle.fill"
        case .restroom:
            return "figure.stand.line.dotted.figure.stand.circle.fill"
        case .school:
            return "graduationcap.circle.fill"
        case .stadium:
            return "sportscourt.fill"
        case .store:
            return "bag.fill"
        case .theater:
            return "film.circle.fill"
        case .university:
            return "graduationcap.circle.fill"
        case .winery:
            return "leaf.circle.fill"
        case .zoo:
            return "hare.circle.fill"
        default:
            return "mappin.circle.fill"
    }
}

