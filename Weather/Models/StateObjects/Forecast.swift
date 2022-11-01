//
//  Forecast.swift
//  Weather
//
//  Created by Vladislav on 28.10.22.
//

import Foundation

struct Forecast: Decodable {
    let currentWeather: CurrentWeather
    let hourlyUnits: HourlyUnits
    let hourly: Hourly
    let dailyUnits: DailyUnits
    let daily: Daily
}

extension Forecast {
    struct CurrentWeather: Decodable {
        let temperature: Double
        let weathercode: Weathercode
        let time: String
    }
    
    enum Weathercode: Int, Decodable {
        case clearSky = 0
        case mainlyClear = 1
        case partlyCloudy = 2
        case overCast = 3
        case fog = 45
        case depositingRimeFog = 48
        case drizzleLight = 51
        case drizzleModerate = 53
        case drizzleDense = 55
        case freezingDrizzleLight = 56
        case freezingDrizzleDense = 57
        case rainSlight = 61
        case rainModerate = 63
        case rainHeavy = 65
        case freezingRainLight = 66
        case freezingRainHeavy = 67
        case snowFallSlight = 71
        case snowFallModerate = 73
        case snowFallHeavy = 75
        case snowGrains = 77
        case rainShowerSlight = 80
        case rainShowerModerate = 81
        case rainShowerViolent = 82
        case snowShowerSlight = 85
        case snowShowerHeavy = 86
        case thunderstorm = 95
        case thunderstormSlightHail = 96
        case thunderstormHeavyHail = 99
    }
    
    struct HourlyUnits: Decodable {
        let temperature2M: String
        let relativehumidity2M: String
        let precipitation: String
        let cloudcover: String
        let windspeed10M: String
    }
    
    struct Hourly: Decodable {
        let time: [String]
        let temperature2M: [Double?]
        let relativehumidity2M: [Int?]
        let precipitation: [Double?]
        let cloudcover: [Int?]
        let windspeed10M: [Double?]
    }
    
    struct DailyUnits: Decodable {
        let temperature2MMax: String
        let temperature2MMin: String
    }
    
    struct Daily: Decodable {
        let time: [String]
        let weathercode: [Weathercode]
        let temperature2MMax: [Double]
        let temperature2MMin: [Double]
    }
}
