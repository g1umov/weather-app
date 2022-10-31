//
//  AppCoordinator.swift
//  Weather
//
//  Created by Vladislav on 31.10.22.
//

import UIKit

final class AppCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let viewControllersFactory: ViewControllersFactory
    
    private weak var locationViewController: UIViewController?
    private weak var citiesInput: CitiesPresenterAppInput?
    
    init(navigationController: UINavigationController,
         viewControllersFactory: ViewControllersFactory) {
        self.navigationController = navigationController
        self.viewControllersFactory = viewControllersFactory
    }
    
    var viewController: UIViewController {
        return navigationController
    }
    
    func configure() {
        configureCities()
    }
    
    private func configureCities() {
        let viewController = viewControllersFactory.createCities(output: self) { input in
            self.citiesInput = input
        }
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentLocation))
        navigationController.viewControllers = [viewController]
        viewController.navigationItem.title = "Cities"
        viewController.navigationItem.rightBarButtonItem = barButtonItem
        viewController.navigationItem.rightBarButtonItem!.tintColor = .white
    }
    
    @objc private func presentLocation() {
        let viewController = viewControllersFactory.createLocation(output: self)
        locationViewController = viewController
        navigationController.present(viewController, animated: true)
    }
    
}

extension AppCoordinator: LocationPresenterAppOutput {
    func didSelectLocation(_ location: Location) {
        citiesInput?.insertLocation(location)
        locationViewController?.dismiss(animated: true)
    }
}

extension AppCoordinator: CitiesPresenterAppOutput {
    func didSelectLocation(_ location: Location, with forecast: Forecast) {
        print(location)
    }
}
