//
//  UIImage + Extensions.swift
//  Weather
//
//  Created by Vladislav on 01.11.22.
//

import UIKit

extension UIImage {
    convenience init?(weathercode: Forecast.Weathercode) {
        let imageName: String
        switch weathercode {
        case .clearSky:
            imageName = "sun.max.fill"
        case .partlyCloudy, .mainlyClear:
            imageName = "cloud.sun"
        case .overCast:
            imageName = "cloud"
        case .fog, .depositingRimeFog:
            imageName = "cloud.fog"
        case .drizzleLight, .drizzleModerate, .drizzleDense, .freezingDrizzleLight, .freezingDrizzleDense:
            imageName = "cloud.drizzle.fill"
        case .rainSlight, .rainModerate, .rainHeavy:
            imageName = "cloud.rain.fill"
        case .freezingRainLight, .freezingRainHeavy:
            imageName = "cloud.sun.rain"
        case .snowFallSlight, .snowFallModerate, .snowFallHeavy, .snowGrains:
            imageName = "snow"
        case .rainShowerSlight, .rainShowerModerate, .rainShowerViolent:
            imageName = "cloud.rain"
        case .snowShowerSlight, .snowShowerHeavy:
            imageName = "cloud.snow"
        case .thunderstorm, .thunderstormHeavyHail, .thunderstormSlightHail:
            imageName = "wind"
        }
        
        self.init(systemName: imageName)
    }
}
