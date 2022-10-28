//
//  WeatherService.swift
//  Weather
//
//  Created by Vladislav on 28.10.22.
//

import Foundation

protocol WeatherService {
    typealias CompletionHandler = (Result<Forecast, Error>) -> Void
    
    func getForecast(for location: Location.Coordinate, completionHandler: @escaping CompletionHandler)
}

class WeatherServiceImpl: WeatherService {
    private let networkService: NetwrorkService
    private lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    init(networkService: NetwrorkService) {
        self.networkService = networkService
    }
    
    func getForecast(for coordinate: Location.Coordinate, completionHandler: @escaping CompletionHandler) {
        let currentDate = Date()
        let endDateValue = 7
        let endDate = Calendar.current.date(byAdding: .day, value: endDateValue, to: currentDate)!
        let endpoint = WeatherEndpoint(coordinate: coordinate,
                                       startDate: currentDate,
                                       endDate: endDate,
                                       currentWeather: true,
                                       windspeedUnit: .ms,
                                       hourlyOptions: WeatherEndpoint.HourlyOption.allCases,
                                       dailyOptions: WeatherEndpoint.DailyOption.allCases)
        networkService.request(endpoint,
                               jsonDecoder: jsonDecoder,
                               completionHandler: completionHandler)
    }
}
