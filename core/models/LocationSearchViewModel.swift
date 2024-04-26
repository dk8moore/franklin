//
//  LocationSearchViewModel.swift
//  franklin
//
//  Created by Denis Ronchese on 05/04/24.
//

import MapKit
import Combine

class LocationSearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults: [MKMapItem] = []
    @Published var selectedPlace: MKMapItem?
    var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 45.43713, longitude: 12.33265), // Venice
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
    private var cancellables: Set<AnyCancellable> = []
    private var locationManager = LocationManager()
    
    init(defaultLocation: MKMapItem? = nil) {
        if let location = defaultLocation {
            selectedPlace = location
            searchResults.append(location)
        }
        
        $searchText
            .removeDuplicates()
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .sink { [weak self] searchText in
                self?.performSearch(query: searchText)
            }
            .store(in: &cancellables)
    }
    
    func setSelectedPlace(_ place: MKMapItem) {
        self.selectedPlace = place
    }
    
    private func performSearch(query: String) {
        guard !query.isEmpty else {
            searchResults = selectedPlace != nil ? [selectedPlace!]: []
            return
        }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
//        request.region = region

        MKLocalSearch(request: request).start { [weak self] response, _ in
            guard let self = self else { return }
            var newResults = response?.mapItems ?? []
            if let selected = self.selectedPlace, !newResults.contains(where: { $0.isEquivalent(to: selected) }) {
                newResults.insert(selected, at: 0)
            }
            self.searchResults = newResults
        }
    }
}

extension MKMapItem {
    func isEquivalent(to other: MKMapItem?) -> Bool {
        guard let other = other else { return false }
        return placemark.coordinate.latitude == other.placemark.coordinate.latitude &&
               placemark.coordinate.longitude == other.placemark.coordinate.longitude
    }
}

extension MKMapItem {
    var isInvalid: Bool {
        return placemark.location == nil
    }
}


