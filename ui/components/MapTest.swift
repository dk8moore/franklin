//
//  MapTest.swift
//  franklin
//
//  Created by Denis Ronchese on 07/04/24.
//

import MapKit
import SwiftUI

struct MapTest: View {
    @State var search = ""
    @State private var sliderRadius = 0.05 // Represents the radius in slider value
    @State private var innerCircleRadius: Double = 34 // Initial value based on the default slider position
    // Assuming an initial ratio between inner and outer circles, adjust as needed
    let radiusRatio: Double = 5/3 // Example ratio, adjust based on your requirements
    
    
    // Using a computed property or a closure to initialize complex properties
    var location: MKMapItem {
        let coordinate = CLLocationCoordinate2D(latitude: 40.6892, longitude: -74.0445)
        let placemark = MKPlacemark(coordinate: coordinate)
        let location = MKMapItem(placemark: placemark)
        location.name = "some custom" // Setting the name here
        return location
    }
    
    var body: some View {
        VStack {
            SearchFieldView(searchText: $search, placeholderText: "Just a test")
            Spacer()
            ZStack {
                Map {
                    Marker(item: location)
                    MapCircle(center: location.placemark.coordinate, radius: innerCircleRadius)
                        .foregroundStyle(.blue.opacity(0.3))
                        .stroke(.blue, lineWidth: 5)
                    MapCircle(center: location.placemark.coordinate, radius: innerCircleRadius * radiusRatio)
                        .foregroundStyle(.white.opacity(0))
                }
                .onChange(of: sliderRadius) {
                    // Adjust the map region for zooming effect using the slider value
                    innerCircleRadius = mapZoomToRadius(sliderRadius)
                }
                .padding(0)
                .edgesIgnoringSafeArea(.all)
                VStack {
                    // This text should be on the top of the map, covering the first part on top of the map itself
                    Text("The schedule will turn on and off when you arrive at and leave this location. Use the slider to modify the radius.")
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                        .font(.footnote)
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.9))
                    Spacer()
                    // This should be on the bottom part of the map, map will be displayed full screen so ignoring the safe zones, but I
                    // want that this slider is place within the safe zone, as the bottom part of the map (still over the map)
                    Slider(value: $sliderRadius, in: 0...1, step: 0.001)
                        .padding()
                }
            }
            .frame(height: UIScreen.main.bounds.height / 2.5)
        }
    }
    
    // Converts the slider value to a radius value for the inner circle
    // Adjust this function to change how the slider value maps to the circle radius
    func mapZoomToRadius(_ value: Double) -> Double {
        // Linear interpolation between 20 meters (at 0.0) and 40 meters (at 0.1), then extrapolate
        let minRadius: Double = 20
        let maxRadius: Double = 500
        let radiusRange = maxRadius - minRadius
        // Slider value of 0.1 corresponds to maxRadius, so we adjust the scaling factor accordingly
        return minRadius + radiusRange * value
    }

}


struct MapTest_Previews: PreviewProvider {
    static var previews: some View {
        MapTest()
    }
}
