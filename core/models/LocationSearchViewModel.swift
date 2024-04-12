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
    
    init() {
        $searchText
            .removeDuplicates()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] searchText in
                self?.performSearch(query: searchText)
            }
            .store(in: &cancellables)
    }
    
    private func performSearch(query: String) {
        guard !query.isEmpty else {
            self.searchResults = []
            return
        }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = region

        MKLocalSearch(request: request).start { [weak self] response, _ in
            self?.searchResults = response?.mapItems ?? []
        }
    }
}

