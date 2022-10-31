//
//  CitySearchService.swift
//  Weather
//
//  Created by Vladislav on 24.10.22.
//

import CoreLocation

protocol LocationService {
    typealias CompletionHandler = (Result<[Location], Error>) -> Void
    
    func geocode(addressString: String, completionHandler: @escaping CompletionHandler)
}

final class LocationServiceImpl: LocationService {
    private let geocoder = CLGeocoder()
    
    func geocode(addressString: String, completionHandler: @escaping CompletionHandler) {
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if let error = error {
                completionHandler(.failure(error))
            } else if let _placemarks = placemarks {
                let locations = _placemarks.compactMap({ (placemark) -> Location? in
                    guard let name = placemark.name else { return nil }
                    guard let state = placemark.administrativeArea else { return nil }
                    guard let country = placemark.country else { return nil }
                    guard let location = placemark.location else { return nil }
                    
                    let coordinate = Location.Coordinate(latitude: location.coordinate.latitude,
                                                         longitude: location.coordinate.longitude)
                    
                    return Location(city: name, state: state, country: country, coordinate: coordinate)
                })
                        
                completionHandler(.success(locations))
            }
        }
    }
    
}
