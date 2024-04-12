//
//  LocationConditionView.swift
//  franklin
//
//  Created by Denis Ronchese on 29/03/24.
//

// LocationConditionView.swift

import SwiftUI
import MapKit

struct LocationConditionView: View {
    @StateObject private var viewModel = LocationSearchViewModel()
    @State private var selectedLocation = MKMapItem()
    @State private var showingMap = false
    @State private var circleScreenRadius: CGFloat = 100 // The constant screen radius of the circle

    var body: some View {
        NavigationView {
            VStack {
                SearchFieldView(searchText: $viewModel.searchText, placeholderText: "Search or Enter Address")
                SearchResultList(searchResults: viewModel.searchResults, selectedResult: $selectedLocation, showingMap: $showingMap)
                if showingMap {
                    MapView(location: $selectedLocation)
                        .frame(height: UIScreen.main.bounds.height / 2.5)
                }
            }
        }
    }
}

struct MapView: View {
    @Binding var location: MKMapItem
    @State private var sliderRadius = 0.05 // Represents the radius in slider value
    @State private var innerCircleRadius: Double = 34 // Initial value based on the default slider position
    // Assuming an initial ratio between inner and outer circles, adjust as needed
    let radiusRatio: Double = 5/3 // Example ratio, adjust based on your requirements
    
    var body: some View {
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
            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            
            VStack {
                Text("The schedule will turn on and off when you arrive at and leave this location. Use the slider to modify the radius.")
                    .padding(.vertical, 10)
                    .padding(.horizontal, 25)
                    .font(.footnote)
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.9))
                Spacer()
                Slider(value: $sliderRadius, in: 0...1, step: 0.001)
                    .padding()
            }
        }
    }
    
    // Converts the slider value to a radius value for the inner circle
    // Adjust this function to change how the slider value maps to the circle radius
    func mapZoomToRadius(_ value: Double) -> Double {
        let minRadius: Double = 20
        let maxRadius: Double = 500
        let radiusRange = maxRadius - minRadius
        return minRadius + radiusRange * value
    }

}

struct SearchResultList: View {
    var searchResults: [MKMapItem]
    @Binding var selectedResult: MKMapItem
    @Binding var showingMap: Bool
    
    var body: some View {
        List(searchResults, id: \.self) { place in
            HStack {
                Image(systemName: iconForMapItem(place))
                    .foregroundColor(.red)
                    .font(.system(size: 35))
                VStack(alignment: .leading) {
                    Text(place.name ?? "Unknown")
                        .font(.headline)
                    Text(place.placemark.title ?? "No Address")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                if (showingMap && isPlaceSelected(place)) {
                    Spacer()
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
            .onTapGesture {
                showingMap = true
                selectedResult = place
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private func isPlaceSelected(_ place: MKMapItem) -> Bool {
        // Attempt to uniquely identify a place by comparing the latitude and longitude
        // This might need adjustments based on your specific requirements
        return place.placemark.coordinate.latitude == selectedResult.placemark.coordinate.latitude &&
               place.placemark.coordinate.longitude == selectedResult.placemark.coordinate.longitude
    }
}

struct LocationConditionView_Previews: PreviewProvider {
    static var previews: some View {
        LocationConditionView()
    }
}
