//
//  LocationPersistenceService.swift
//  Weather
//
//  Created by Vladislav on 30.10.22.
//

import Foundation

protocol LocationPersistenceService {
    func create(location: Location, completionHandler: @escaping (Result<Location, Error>) -> Void)
    func getLocations(completionHandler: @escaping (Result<[Location], Error>) -> Void)
}

final class LocationPersistenceServiceImpl: LocationPersistenceService {
    private let persistenceController: PersistenceController
    
    init(persistenceController: PersistenceController) {
        self.persistenceController = persistenceController
    }
    
    func create(location: Location, completionHandler: @escaping (Result<Location, Error>) -> Void) {
        do {
            let _ = mapLocation(location)
            try persistenceController.viewContext.save()
            completionHandler(.success(location))
        } catch {
            completionHandler(.failure(error))
            NSLog("Unable to create City entity, \(error)")
        }
    }
    
    func getLocations(completionHandler: @escaping (Result<[Location], Error>) -> Void) {
        do {
            let cities = try persistenceController.viewContext.fetch(City.fetchRequest())
            let locations = try cities.compactMap { try mapCity($0) }
            completionHandler(.success(locations))
        } catch {
            completionHandler(.failure(error))
            NSLog("Unable to fetch list of City objects, \(error)")
        }
    }
    
    private func mapLocation(_ location: Location) -> City {
        let city = City(context: persistenceController.viewContext)
        city.name = location.city
        city.state = location.state
        city.country = location.country
        city.longitude = location.coordinate.longitude
        city.latitude = location.coordinate.latitude
        return city
    }
    
    private func mapCity(_ managedObject: City) throws -> Location {
        guard let city = managedObject.name,
              let state = managedObject.state,
              let country = managedObject.country else {
            throw LocationPersistenceServiceError.failedMapping
        }
        
        let coordinate = Location.Coordinate(latitude: managedObject.latitude, longitude: managedObject.longitude)
        return Location(city: city, state: state, country: country, coordinate: coordinate)
    }
}

extension LocationPersistenceServiceImpl {
    enum LocationPersistenceServiceError: LocalizedError {
        case failedMapping
    }
}
