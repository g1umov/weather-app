//
//  ForecastViewModel.swift
//  Weather
//
//  Created by Vladislav on 31.10.22.
//

import Foundation

struct ForecastHeaderViewModel {
    let city: String
    let weathercode: String
    let temperature: String
}

struct ForecastDailyViewModel {
    let weekdays: [String]
    let weathercodes: [Forecast.Weathercode]
    let minTemperature: [String]
    let maxTemperature: [String]
}

struct ForecastDetailViewModel {
    let title: String
    let text: String
}
