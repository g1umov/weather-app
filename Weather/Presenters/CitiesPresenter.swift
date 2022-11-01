//
//  CitiesPresenter.swift
//  Weather
//
//  Created by Vladislav on 30.10.22.
//

import Foundation

protocol CitiesPresenter {
    func prepareCities()
    func updateForecasts()
    func selectCity(index: Int)
}

protocol CitiesPresenterViewOutput: AnyObject {
    func present(viewModels: [CityViewModel])
    func update(viewModels: [CityViewModel])
    func insert(viewModel: CityViewModel)
    func present(error: String)
}

protocol CitiesPresenterAppInput: AnyObject {
    func insertLocation(_ location: Location)
}

protocol CitiesPresenterAppOutput: AnyObject {
    func didSelectLocation(_ location: Location, with forecast: Forecast)
}

final class CitiesPresenterImpl: CitiesPresenter {
    private let locationPersistence: LocationPersistenceService
    private let weatherService: WeatherService
    private let dispatchGroup = DispatchGroup()
    
    private var locations: [Location] = []
    private var forecasts: [Location: Forecast] = [:]
    
    private var actionState: ActionState = .none
    
    weak var viewOutput: CitiesPresenterViewOutput?
    weak var appOutput: CitiesPresenterAppOutput?
    
    init(locationPersistence: LocationPersistenceService,
         weatherService: WeatherService) {
        self.locationPersistence = locationPersistence
        self.weatherService = weatherService
    }
    
    func prepareCities() {
        actionState = .preparing
        loadCities()
    }
    
    func updateForecasts() {
        actionState = .updating
        loadForecasts(with: locations)
    }
    
    func selectCity(index: Int) {
        guard locations.count >= index else { return }
        
        let selectedLocation = locations[index]
        if let selectedForecast = forecasts[selectedLocation] {
            appOutput?.didSelectLocation(selectedLocation, with: selectedForecast)
        }
    }
    
    private func loadCities() {
        locationPersistence.getLocations { [weak self] result in
            guard let _self = self else { return }
            
            switch result {
            case .success(let locations):
                _self.handleSuccess(of: locations)
            case .failure(let error):
                _self.handleFailure(with: error)
            }
        }
    }
    
    private func handleSuccess(of locations: [Location]) {
        guard !locations.isEmpty else {
            viewOutput?.present(error: "Locations was not found")
            actionState = .none
            return
        }
        
        self.locations = locations
        loadForecasts(with: locations)
    }
    
    private func handleFailure(with error: Error) {
        viewOutput?.present(error: "Unable to load list of cities")
        actionState = .none
    }
    
    private func loadForecasts(with locations: [Location]) {
        locations.forEach { location in
            dispatchGroup.enter()
            loadForecast(with: location) { [weak self] in
                guard let _self = self else { return }
                _self.dispatchGroup.leave()
            }
        }
        
        setupDispatchGroup()
    }
    
    private func loadForecast(with location: Location, completionHandler: @escaping () -> Void) {
        weatherService.getForecast(for: location.coordinate) { [weak self] result in
            guard let _self = self else { return }
            
            if case let .success(forecast) = result {
                _self.forecasts[location] = forecast
            }
            
            completionHandler()
        }
    }
    
    private func setupDispatchGroup() {
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let _self = self else { return }
            
            let viewModels = _self.locations.map { _self.mapToViewModel($0) }
            switch _self.actionState {
            case .preparing:
                _self.viewOutput?.present(viewModels: viewModels)
            case .updating:
                _self.viewOutput?.update(viewModels: viewModels)
            case .none:
                break
            }
            
            _self.actionState = .none
        }
    }
    
    private func mapToViewModel(_ location: Location) -> CityViewModel {
        if let forecast = forecasts[location] {
            let weathercode = forecast.currentWeather.weathercode
            let temperature = String(forecast.currentWeather.temperature)
            return CityViewModel(city: location.city, weathercode: weathercode, temperature: temperature)
        }
        
        return CityViewModel(city: location.city, weathercode: nil, temperature: "null")
    }
}

extension CitiesPresenterImpl: CitiesPresenterAppInput {
    func insertLocation(_ location: Location) {
        locations.append(location)
        locationPersistence.create(location: location) { _ in }
        loadForecast(with: location) { [weak self] in
            guard let _self = self else { return }
            
            let viewModel = _self.mapToViewModel(location)
            _self.viewOutput?.insert(viewModel: viewModel)
        }
    }
}

extension CitiesPresenterImpl {
    enum ActionState {
        case none
        case preparing
        case updating
    }
}
