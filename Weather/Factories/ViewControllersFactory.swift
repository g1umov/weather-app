//
//  ViewControllersFactory.swift
//  Weather
//
//  Created by Vladislav on 24.10.22.
//

import UIKit

class ViewControllersFactory {
    
    func createLocation(selectionHandler: @escaping LocationSelectionHandler) -> UIViewController {
        let service = LocationServiceImpl()
        let presenter = LocationPresenterImpl(locationService: service)
        let locactionController = LocationViewController(presenter: presenter)
        
        presenter.delegate = locactionController
        presenter.selectionHandler = selectionHandler
        
        return UINavigationController(rootViewController: locactionController)
    }
    
}
