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

protocol CitiesPresenterDelegate: AnyObject {
    func present(viewModels: [CityViewModel])
    func update(viewModels: [CityViewModel])
    func present(error: String)
}

final class CitiesPresenterImpl: CitiesPresenter {
    private let locationPersistence: LocationPersistenceService
    private let weatherService: WeatherService
    private let dispatchGroup = DispatchGroup()
    
    // MARK: Dat cache
    
    private var locations: [Location] = []
    private var forecasts: [Location: Forecast] = [:]
    
    // MARK: Helper flags
    
    private var actionState: ActionState = .none
    
    // MARK: Outer dependecies
    
    weak var delegate: CitiesPresenterDelegate?
    var selectingHadnler: ((Location, Forecast) -> Void)?
    
    init(locationPersistence: LocationPersistenceService,
         weatherService: WeatherService) {
        self.locationPersistence = locationPersistence
        self.weatherService = weatherService
    }
    
    // MARK: CitiesPresenter methods
    
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
            selectingHadnler?(selectedLocation, selectedForecast)
        }
    }
    
    // MARK: Helper methods
    
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
            delegate?.present(error: "Locations was not found")
            actionState = .none
            return
        }
        
        self.locations = locations
        loadForecasts(with: locations)
    }
    
    private func handleFailure(with error: Error) {
        delegate?.present(error: "Unable to load list of cities")
        actionState = .none
    }
    
    private func loadForecasts(with locations: [Location]) {
        locations.forEach { loadForecast(with: $0) }
        notifyDispatchGroup()
    }
    
    private func loadForecast(with location: Location) {
        dispatchGroup.enter()
        weatherService.getForecast(for: location.coordinate) { [weak self] result in
            guard let _self = self else { return }
            
            if case let .success(forecast) = result {
                _self.forecasts[location] = forecast
            }
            
            _self.dispatchGroup.leave()
        }
    }
    
    private func notifyDispatchGroup() {
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let _self = self else { return }
            
            let viewModels = _self.mapToViewModels()
            switch _self.actionState {
            case .preparing:
                _self.delegate?.present(viewModels: viewModels)
            case .updating:
                _self.delegate?.update(viewModels: viewModels)
            case .none:
                break
            }
            
            _self.actionState = .none
        }
    }
    
    private func mapToViewModels() -> [CityViewModel] {
        return locations.map { location in
            if let forecast = forecasts[location] {
                let weathercode = mapWeathercode(forecast.currentWeather.weathercode)
                let temperature = String(forecast.currentWeather.temperature)
                return CityViewModel(city: location.city, weathercode: weathercode, temperature: temperature)
            }
            
            return CityViewModel(city: location.city, weathercode: "exclamationmark.circle", temperature: "null")
        }
    }
    
    private func mapWeathercode(_ code: Forecast.Weathercode) -> String {
        switch code {
        case .clearSky:
            return "sun.max.fill"
        case .partlyCloudy, .mainlyClear:
            return "cloud.sun"
        case .overCast:
            return "cloud"
        case .fog, .depositingRimeFog:
            return "cloud.fog"
        case .drizzleLight, .drizzleModerate, .drizzleDense, .freezingDrizzleLight, .freezingDrizzleDense:
            return "cloud.drizzle.fill"
        case .rainSlight, .rainModerate, .rainHeavy:
            return "cloud.rain.fill"
        case .freezingRainLight, .freezingRainHeavy:
            return "cloud.sun.rain"
        case .snowFallSlight, .snowFallModerate, .snowFallHeavy, .snowGrains:
            return "snow"
        case .rainShowerSlight, .rainShowerModerate, .rainShowerViolent:
            return "cloud.rain"
        case .snowShowerSlight, .snowShowerHeavy:
            return "cloud.snow"
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
