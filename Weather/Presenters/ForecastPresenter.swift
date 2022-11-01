//
//  ForecastPresenter.swift
//  Weather
//
//  Created by Vladislav on 31.10.22.
//

import Foundation

protocol ForecastPresenter {
    var header: ForecastHeaderViewModel { get }
    var daily: ForecastDailyViewModel { get }
    var details: [ForecastDetailViewModel] { get }
}

struct ForecastPresenterImpl: ForecastPresenter {
    private let forecast: Forecast
    private let location: Location
    
    private let unknownDetailText = "Uknown"
    
    init(forecast: Forecast, location: Location) {
        self.forecast = forecast
        self.location = location
    }
    
    var header: ForecastHeaderViewModel {
        let city = location.city
        let temperature = "\(forecast.currentWeather.temperature) \(forecast.hourlyUnits.temperature2M)"
        let weathercodeRawValue = forecast.currentWeather.weathercode.rawValue
        let weathercode = NSLocalizedString("weathercode-\(weathercodeRawValue)",
                                            tableName: "Weathercodes",
                                            comment: "Weather code")
        
        return ForecastHeaderViewModel(city: city, weathercode: weathercode, temperature: temperature)
    }
    
    var daily: ForecastDailyViewModel {
        let weathercodes = forecast.daily.weathercode
        let minTemp = forecast.daily.temperature2MMin.map { String($0) }
        let maxTemp = forecast.daily.temperature2MMax.map { String($0) }
        
        return ForecastDailyViewModel(weekdays: weekdays,
                                      weathercodes: weathercodes,
                                      minTemperature: minTemp,
                                      maxTemperature: maxTemp)
    }
    
    var details: [ForecastDetailViewModel] {
        return [precipitation, windSpeed, cloudCover, humidity]
    }
    
    private var weekdays: [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dates = forecast.daily.time.map { dateFormatter.date(from: $0) }
        return dates.map {
            guard let date = $0 else { return "Uknown date" }
            
            if date.hasSame(.day, as: .current) {
                return "Today"
            }
            
            dateFormatter.dateFormat = "EEEE"
            
            return dateFormatter.string(from: date)
        }
    }
    
    private var currentWeatherIndex: Int? {
        let weatherTime = forecast.currentWeather.time
        
        return forecast.hourly.time.firstIndex(of: weatherTime)
    }
    
    private var precipitation: ForecastDetailViewModel {
        let title = "Precipitation intensity"
        
        guard let index = currentWeatherIndex else {
            return ForecastDetailViewModel(title: title, text: unknownDetailText)
        }
        
        guard let value = forecast.hourly.precipitation[index] else {
            return ForecastDetailViewModel(title: title, text: unknownDetailText)
        }
        
        let text = "\(value) \(forecast.hourlyUnits.precipitation)"
        
        return ForecastDetailViewModel(title: title, text: text)
    }
    
    private var windSpeed: ForecastDetailViewModel {
        let title = "Wind speed"
        
        guard let index = currentWeatherIndex else {
            return ForecastDetailViewModel(title: title, text: unknownDetailText)
        }
        
        guard let value = forecast.hourly.windspeed10M[index] else {
            return ForecastDetailViewModel(title: title, text: unknownDetailText)
        }
        
        let text = "\(value) \(forecast.hourlyUnits.windspeed10M)"
        
        return ForecastDetailViewModel(title: title, text: text)
    }
    
    private var cloudCover: ForecastDetailViewModel {
        let title = "Cloud cover"
        
        guard let index = currentWeatherIndex else {
            return ForecastDetailViewModel(title: title, text: unknownDetailText)
        }
        
        guard let value = forecast.hourly.cloudcover[index] else {
            return ForecastDetailViewModel(title: title, text: unknownDetailText)
        }
        
        let text = "\(value) \(forecast.hourlyUnits.cloudcover)"
        
        return ForecastDetailViewModel(title: title, text: text)
    }
    
    private var humidity: ForecastDetailViewModel {
        let title = "Humidity"
        
        guard let index = currentWeatherIndex else {
            return ForecastDetailViewModel(title: title, text: unknownDetailText)
        }
        
        guard let value = forecast.hourly.relativehumidity2M[index] else {
            return ForecastDetailViewModel(title: title, text: unknownDetailText)
        }
        
        let text = "\(value) \(forecast.hourlyUnits.relativehumidity2M)"
        
        return ForecastDetailViewModel(title: title, text: text)
    }
    
}
