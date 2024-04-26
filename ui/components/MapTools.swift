//
//  MapTools.swift
//  franklin
//
//  Created by Denis Ronchese on 11/04/24.
//

import SwiftUI
import MapKit
import FontAwesome

enum IconType {
    case sfSymbol(name: String)
    case faIcon(name: FontAwesome)

    func image(forSize size: CGSize, color: UIColor) -> UIImage {
        switch self {
        case .sfSymbol(let name):
            if let image = UIImage(systemName: name, withConfiguration: UIImage.SymbolConfiguration(pointSize: size.width, weight: .regular, scale: .default)) {
                return image.withTintColor(color, renderingMode: .alwaysTemplate)
            } else {
                return UIImage()
            }
        case .faIcon(let name):
            // FontAwesome icons handle their own coloring through the fontAwesomeIcon method.
            return UIImage.fontAwesomeIcon(name: name, style: .solid, textColor: color, size: size)
        }
    }
}

struct IconDetails {
    var iconType: IconType
    var backgroundColor: UIColor
}

struct IconView: View {
    let iconDetails: IconDetails
    var color: Color = .white
    var iconSize: CGFloat = 17    // This controls the size of the icon inside the circle
    var circleSize: CGFloat = 30  // This controls the size of the circle

    var body: some View {
        ZStack {
            Circle()
                .fill(Color(iconDetails.backgroundColor))
                .frame(width: circleSize, height: circleSize)
            Image(uiImage: iconDetails.iconType.image(forSize: CGSize(width: iconSize, height: iconSize), color: UIColor(color)))
                .resizable()
                .scaledToFit()
                .frame(width: iconSize, height: iconSize)
        }
        .foregroundColor(color) // This sets the color of the SF Symbols
    }
}


func iconForMapItem(_ mapItem: MKMapItem) -> IconDetails {
    let defaultIcon = IconDetails(iconType: .sfSymbol(name: "mappin"), backgroundColor: .red)

    guard let category = mapItem.pointOfInterestCategory else {
        return defaultIcon
    }
    
    switch category {
        case .airport:
            return IconDetails(iconType: .sfSymbol(name: "airplane"), backgroundColor: .systemBlue)
//        case .amusementPark:
//            return IconDetails(iconType: .faIcon(name: .ferrisWheel), backgroundColor: .purple)  // Panoramic wheel
        case .aquarium:
        return IconDetails(iconType: .faIcon(name: .fish), backgroundColor: UIColor(red: 255/255, green: 111/255, blue: 174/255, alpha: 1.0))  // Dolphin
//        case .atm:
//            return IconDetails(iconType: .faIcon(name: .atm), backgroundColor: .gray)  // ATM with card slot
        case .bakery:
            return IconDetails(iconType: .faIcon(name: .breadSlice), backgroundColor: UIColor(red: 255/255, green: 143/255, blue: 32/255, alpha: 1.0))  // Croissant
        case .bank:
            return IconDetails(iconType: .sfSymbol(name: "building.columns.fill"), backgroundColor: UIColor(red: 162/255, green: 161/255, blue: 158/255, alpha: 1.0))
        case .beach:
            return IconDetails(iconType: .faIcon(name: .umbrellaBeach), backgroundColor: UIColor(red: 0/255, green: 192/255, blue: 255/255, alpha: 1.0))
        case .brewery:
            return IconDetails(iconType: .faIcon(name: .beer), backgroundColor: UIColor(red: 255/255, green: 143/255, blue: 32/255, alpha: 1.0))
        case .cafe:
            return IconDetails(iconType: .faIcon(name: .coffee), backgroundColor: UIColor(red: 255/255, green: 143/255, blue: 32/255, alpha: 1.0))
        case .campground:
            return IconDetails(iconType: .faIcon(name: .campground), backgroundColor: UIColor(red: 33/255, green: 184/255, blue: 2/255, alpha: 1.0))
        case .carRental:
            return IconDetails(iconType: .sfSymbol(name: "car.2.fill"), backgroundColor: UIColor(red: 162/255, green: 161/255, blue: 158/255, alpha: 1.0))
        case .evCharger:
            return IconDetails(iconType: .sfSymbol(name: "ev.charger.fill"), backgroundColor: UIColor(red: 0/255, green: 207/255, blue: 107/255, alpha: 1.0))
        case .fireStation:
            return IconDetails(iconType: .faIcon(name: .fireExtinguisher), backgroundColor: .red)
        case .fitnessCenter:
            return IconDetails(iconType: .faIcon(name: .dumbbell), backgroundColor: UIColor(red: 0/255, green: 192/255, blue: 255/255, alpha: 1.0))
        case .foodMarket:
            return IconDetails(iconType: .faIcon(name: .shoppingCart), backgroundColor: UIColor(red: 255/255, green: 176/255, blue: 2/255, alpha: 1.0))
        case .gasStation:
            return IconDetails(iconType: .sfSymbol(name: "fuelpump.fill"), backgroundColor: UIColor(red: 42/255, green: 138/255, blue: 239/255, alpha: 1.0))
        case .hospital:
            return IconDetails(iconType: .sfSymbol(name: "cross.fill"), backgroundColor: .red)
        case .hotel:
            return IconDetails(iconType: .faIcon(name: .bed), backgroundColor: UIColor(red: 168/255, green: 123/255, blue: 242/255, alpha: 1.0))
        case .laundry:
            return IconDetails(iconType: .faIcon(name: .soap), backgroundColor: UIColor(red: 255/255, green: 176/255, blue: 2/255, alpha: 1.0))
        case .library:
            return IconDetails(iconType: .faIcon(name: .book), backgroundColor: UIColor(red: 176/255, green: 108/255, blue: 57/255, alpha: 1.0))
        case .marina:
            return IconDetails(iconType: .sfSymbol(name: "sailboat.fill"), backgroundColor: UIColor(red: 0/255, green: 192/255, blue: 255/255, alpha: 1.0))
        case .movieTheater:
            return IconDetails(iconType: .faIcon(name: .film), backgroundColor: UIColor(red: 255/255, green: 111/255, blue: 174/255, alpha: 1.0))
        case .museum:
            return IconDetails(iconType: .faIcon(name: .landmark), backgroundColor: UIColor(red: 255/255, green: 111/255, blue: 174/255, alpha: 1.0))
        case .nationalPark:
            return IconDetails(iconType: .faIcon(name: .tree), backgroundColor: UIColor(red: 33/255, green: 184/255, blue: 2/255, alpha: 1.0))
        case .nightlife:
            return IconDetails(iconType: .sfSymbol(name: "music.note"), backgroundColor: UIColor(red: 255/255, green: 111/255, blue: 174/255, alpha: 1.0))
        case .park:
            return IconDetails(iconType: .sfSymbol(name: "tree.fill"), backgroundColor: UIColor(red: 33/255, green: 184/255, blue: 2/255, alpha: 1.0))
        case .parking:
            return IconDetails(iconType: .sfSymbol(name: "parkingsign"), backgroundColor: UIColor(red: 42/255, green: 138/255, blue: 239/255, alpha: 1.0))
        case .pharmacy:
            return IconDetails(iconType: .sfSymbol(name: "pills.fill"), backgroundColor: .red)
        case .police:
            return IconDetails(iconType: .sfSymbol(name: "staroflife.shield"), backgroundColor: UIColor(red: 162/255, green: 161/255, blue: 158/255, alpha: 1.0))
        case .postOffice:
            return IconDetails(iconType: .sfSymbol(name: "envelope.fill"), backgroundColor: UIColor(red: 162/255, green: 161/255, blue: 158/255, alpha: 1.0))
        case .publicTransport:
            return IconDetails(iconType: .faIcon(name: .subway), backgroundColor: UIColor(red: 42/255, green: 138/255, blue: 239/255, alpha: 1.0))
        case .restaurant:
            return IconDetails(iconType: .sfSymbol(name: "fork.knife"), backgroundColor: UIColor(red: 255/255, green: 143/255, blue: 32/255, alpha: 1.0))
        case .restroom:
            return IconDetails(iconType: .faIcon(name: .restroom), backgroundColor: UIColor(red: 168/255, green: 123/255, blue: 242/255, alpha: 1.0))  // Figure stand, restroom related
        case .school:
            return IconDetails(iconType: .faIcon(name: .school), backgroundColor: UIColor(red: 176/255, green: 108/255, blue: 57/255, alpha: 1.0))
        case .stadium:
            return IconDetails(iconType: .sfSymbol(name: "sportscourt.fill"), backgroundColor: UIColor(red: 33/255, green: 184/255, blue: 2/255, alpha: 1.0))  // Sports related
        case .store:
            return IconDetails(iconType: .faIcon(name: .store), backgroundColor: UIColor(red: 255/255, green: 176/255, blue: 2/255, alpha: 1.0))
        case .theater:
            return IconDetails(iconType: .faIcon(name: .theaterMasks), backgroundColor: UIColor(red: 255/255, green: 111/255, blue: 174/255, alpha: 1.0))
        case .university:
            return IconDetails(iconType: .sfSymbol(name: "graduationcap.fill"), backgroundColor: UIColor(red: 176/255, green: 108/255, blue: 57/255, alpha: 1.0))
        case .winery:
            return IconDetails(iconType: .faIcon(name: .wineGlass), backgroundColor: UIColor(red: 255/255, green: 111/255, blue: 174/255, alpha: 1.0))  // Vine leaf, wine related
        case .zoo:
            return IconDetails(iconType: .sfSymbol(name: "pawprint.fill"), backgroundColor: UIColor(red: 255/255, green: 111/255, blue: 174/255, alpha: 1.0))  // Animal, zoo related
        default:
            return IconDetails(iconType: .sfSymbol(name: "mappin"), backgroundColor: .gray)
    }
}


