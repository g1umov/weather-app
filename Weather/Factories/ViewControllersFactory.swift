//
//  ViewControllersFactory.swift
//  Weather
//
//  Created by Vladislav on 24.10.22.
//

import UIKit

final class ViewControllersFactory {
    
    func createLocation(output delegate: LocationPresenterAppOutput) -> UIViewController {
        let service = LocationServiceImpl()
        let presenter = LocationPresenterImpl(locationService: service)
        let viewController = LocationViewController(presenter: presenter)
        
        presenter.viewOutput = viewController
        presenter.appOutput = delegate
        
        return UINavigationController(rootViewController: viewController)
    }
    
    func createCities(output delegate: CitiesPresenterAppOutput, input configurator: (CitiesPresenterAppInput) -> Void) -> UIViewController {
        let persistenceController = PersistenceController(modelName: "weather")
        let locationPersistence = LocationPersistenceServiceImpl(persistenceController: persistenceController)
        
        let networkService = NetworkServiceImpl()
        let weatherService = WeatherServiceImpl(networkService: networkService)
        
        let presenter = CitiesPresenterImpl(locationPersistence: locationPersistence, weatherService: weatherService)
        let viewController = CitiesViewController(presenter: presenter)
        
        presenter.viewOutput = viewController
        presenter.appOutput = delegate
        configurator(presenter)
        
        // FIXME: Invoke in app delegate
        persistenceController.loadPersistentStores(completionHandler: nil)
        
        return viewController
    }
    
}
