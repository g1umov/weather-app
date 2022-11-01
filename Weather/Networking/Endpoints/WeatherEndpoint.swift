//
//  WeatherEndpoint.swift
//  Weather
//
//  Created by Vladislav on 28.10.22.
//

import Foundation

struct WeatherEndpoint: Endpoint {
    static let baseURLString = "https://api.open-meteo.com/v1/forecast"
    
    let coordinate: Location.Coordinate
    let startDate: Date
    let endDate: Date
    let currentWeather: Bool
    let windspeedUnit: WindspeedUnit
    let hourlyOptions: [HourlyOption]
    let dailyOptions: [DailyOption]
    
    func asURL() throws -> URL {
        guard var urlComponents = URLComponents(string: Self.baseURLString) else {
            throw WeatherEndpointError.failedBaseURL
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "latitude", value: String(coordinate.latitude)),
            URLQueryItem(name: "longitude", value: String(coordinate.longitude)),
            URLQueryItem(name: "current_weather", value: String(currentWeather)),
            URLQueryItem(name: "windspeed_unit", value: windspeedUnit.rawValue),
            URLQueryItem(name: "hourly", value: hourlyOptions.map { $0.rawValue }.joined(separator: ",")),
            URLQueryItem(name: "daily", value: dailyOptions.map { $0.rawValue }.joined(separator: ",")),
            URLQueryItem(name: "start_date", value: convert(from: startDate)),
            URLQueryItem(name: "end_date", value: convert(from: endDate)),
            URLQueryItem(name: "timezone", value: "auto")
        ]
        
        guard let url = urlComponents.url else {
            throw WeatherEndpointError.failedURL
        }
        
        return url
    }
    
    private func convert(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}

extension WeatherEndpoint {
    enum WeatherEndpointError: LocalizedError {
        case failedBaseURL
        case failedURL
    }
}

extension WeatherEndpoint {
    enum WindspeedUnit: String {
        case ms
    }
    
    enum HourlyOption: String, CaseIterable {
        case temperature2m = "temperature_2m"
        case relativehumidity2m = "relativehumidity_2m"
        case precipitation
        case cloudcover
        case windspeed10m = "windspeed_10m"
    }
    
    enum DailyOption: String, CaseIterable {
        case weathercode
        case temperature2mMax = "temperature_2m_max"
        case temperature2mMin = "temperature_2m_min"
    }
}
