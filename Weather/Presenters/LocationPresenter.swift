//
//  LocationPresenter.swift
//  Weather
//
//  Created by Vladislav on 24.10.22.
//

import Foundation

typealias LocationSelectionHandler = ((Location) -> Void)

protocol LocationPresenter {
    func search(inputText: String?)
    func selectLocation(byIndex index: Int)
}

protocol LocationPresenterDelegate: AnyObject {
    func present(locations: [LocationViewModel])
    func present(error: String)
}

class LocationPresenterImpl: LocationPresenter {
    private let locationService: LocationService
    private var locations = [Location]()
    
    weak var delegate: LocationPresenterDelegate?
    var selectionHandler: LocationSelectionHandler?
    
    init(locationService: LocationService) {
        self.locationService = locationService
    }
    
    func search(inputText: String?) {
        guard let _inputText = inputText else { return }
        guard !(_inputText.isEmpty) else { return }
        
        locationService.geocode(addressString: _inputText) { [weak self] result in
            guard let _self = self else { return }
            
            switch result {
            case .success(let locations):
                _self.handleSuccess(locations: locations)
            case .failure(let error):
                _self.handleFailure(error: error)
            }
        }
    }
    
    func selectLocation(byIndex index: Int) {
        guard index <= (locations.count - 1) else { return }
        
        let location = locations[index]
        selectionHandler?(location)
    }
    
    private func handleSuccess(locations: [Location]) {
        self.locations = locations
        
        let viewModels = locations.map { "\($0.name), \($0.state), \($0.country)" }
        delegate?.present(locations: viewModels)
    }
    
    private func handleFailure(error: Error) {
        delegate?.present(error: "No matching location found")
        NSLog("Unable to forward geocode address, \(error)")
    }
    
}
