//
//  LocationPresenter.swift
//  Weather
//
//  Created by Vladislav on 24.10.22.
//

import Foundation

protocol LocationPresenter {
    func search(inputText: String?)
    func selectLocation(byIndex index: Int)
}

protocol LocationPresenterViewOutput: AnyObject {
    func present(locations: [LocationViewModel])
    func present(error: String)
}

protocol LocationPresenterAppOutput: AnyObject {
    func didSelectLocation(_ location: Location)
}

final class LocationPresenterImpl: LocationPresenter {
    private let locationService: LocationService
    private var locations = [Location]()
    
    weak var viewOutput: LocationPresenterViewOutput?
    weak var appOutput: LocationPresenterAppOutput?
    
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
        appOutput?.didSelectLocation(location)
    }
    
    private func handleSuccess(locations: [Location]) {
        self.locations = locations
        
        let viewModels = locations.map { "\($0.city), \($0.state), \($0.country)" }
        viewOutput?.present(locations: viewModels)
    }
    
    private func handleFailure(error: Error) {
        viewOutput?.present(error: "No matching location found")
    }
    
}
