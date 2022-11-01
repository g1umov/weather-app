//
//  LocationPersistenceService.swift
//  Weather
//
//  Created by Vladislav on 30.10.22.
//

import Foundation
import CoreData

protocol LocationPersistenceService {
    func create(location: Location, completionHandler: @escaping (Result<Location, Error>) -> Void)
    func getLocations(completionHandler: @escaping (Result<[Location], Error>) -> Void)
    func deleteLocation(_ location: Location, completionHandler: @escaping (Error?) -> Void)
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
    
    func deleteLocation(_ location: Location, completionHandler: @escaping (Error?) -> Void) {
        do {
            let fetchRequest = City.fetchRequest()
            let latitudePredicate = NSPredicate(format: "latitude = %lf", location.coordinate.latitude)
            let longitudePredicate = NSPredicate(format: "longitude = %lf", location.coordinate.longitude)
            
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                latitudePredicate,
                longitudePredicate
            ])
            
            let cities = try persistenceController.viewContext.fetch(fetchRequest)
            
            guard let city = cities.first else {
                completionHandler(LocationPersistenceServiceError.objectWasNotFound)
                return
            }
            
            persistenceController.viewContext.delete(city)
            try persistenceController.viewContext.save()
            completionHandler(nil)
        } catch {
            completionHandler(error)
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
        case objectWasNotFound
    }
}
