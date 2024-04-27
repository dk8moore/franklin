//
//  LocationConditionView.swift
//  franklin
//
//  Created by Denis Ronchese on 29/03/24.
//

// LocationConditionView.swift

import SwiftUI
import MapKit

#if canImport(UIKit)
extension View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

struct LocationConditionView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var searchModel = LocationSearchViewModel()
    @State private var selectedLocation = MKMapItem()
    @State private var showingMap: Bool
    @State private var circleScreenRadius: Double // The constant screen radius of the circle
    
    var locationCondition: LocationConditionData?
    var onSave: (any ConditionData) -> Void
    
    init(locationCondition: LocationConditionData? = nil, onSave: @escaping (any ConditionData) -> Void) {
        self.onSave = onSave
        self.locationCondition = locationCondition
        
        if let locationCondition = locationCondition {
            _selectedLocation = State(initialValue: locationCondition.location)
            _circleScreenRadius = State(initialValue: locationCondition.radius)
            _showingMap = State(initialValue: true)
            _searchModel = StateObject(wrappedValue: LocationSearchViewModel(defaultLocation: locationCondition.location))
        } else {
            _selectedLocation = State(initialValue: MKMapItem())
            _circleScreenRadius = State(initialValue: 34)
            _showingMap = State(initialValue: false)
            _searchModel = StateObject(wrappedValue: LocationSearchViewModel())
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchFieldView(searchText: $searchModel.searchText, placeholderText: "Search or Enter Address")
                SearchResultList(searchResults: searchModel.searchResults, selectedResult: $selectedLocation, showingMap: $showingMap, viewModel: searchModel)
                    .gesture(DragGesture().onChanged { _ in self.dismissKeyboard() })
                if showingMap {
                    MapView(location: $selectedLocation, innerCircleRadius: $circleScreenRadius)
                        .frame(height: UIScreen.main.bounds.height / 2.5)
                        .ignoresSafeArea(.keyboard)
                }
            }
            .onTapGesture {
                self.dismissKeyboard()
            }
        }
        .navigationTitle("Location")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("Save") {
            let data = LocationConditionData(id: locationCondition?.id ?? UUID(), location: selectedLocation, radius: circleScreenRadius)
            onSave(data)
            presentationMode.wrappedValue.dismiss()
        }
        .disabled(selectedLocation.isEquivalent(to: locationCondition?.location) || selectedLocation.isInvalid))
    }
}

struct MapView: View {
    @Binding var location: MKMapItem
    @Binding var innerCircleRadius: Double // Initial value based on the default slider position
    @State private var sliderRadius: Double = 0.05 // Represents the radius in slider value
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
        .onAppear {
            sliderRadius = radiusToSliderValue(innerCircleRadius)
        }
    }
    
    // Converts the slider value to a radius value for the inner circle
    func mapZoomToRadius(_ value: Double) -> Double {
        let minRadius: Double = 20
        let maxRadius: Double = 500
        return minRadius + (maxRadius - minRadius) * value
    }
    
    func radiusToSliderValue(_ radius: Double) -> Double {
        let minRadius: Double = 20
        let maxRadius: Double = 500
        return (radius - minRadius) / (maxRadius - minRadius)
    }

}

struct SearchResultList: View {
    var searchResults: [MKMapItem]
    @Binding var selectedResult: MKMapItem
    @Binding var showingMap: Bool
    var viewModel: LocationSearchViewModel
    
    var body: some View {
        List(searchResults, id: \.self) { place in
            HStack {
                IconView(iconDetails: iconForMapItem(place))
//                    .padding(.all, 9)
                VStack(alignment: .leading) {
                    Text(place.name ?? "Unknown")
                        .lineLimit(1)
                        .truncationMode(/*@START_MENU_TOKEN@*/.tail/*@END_MENU_TOKEN@*/)
                        .font(.headline)
                    Text(place.placemark.title ?? "No Address")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                        .truncationMode(/*@START_MENU_TOKEN@*/.tail/*@END_MENU_TOKEN@*/)
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
                viewModel.setSelectedPlace(place)
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
        LocationConditionView(onSave: { _ in })
    }
}
