//
//  Location.swift
//  Weather
//
//  Created by Vladislav on 24.10.22.
//

import Foundation

struct Location {
    let city: String
    let state: String
    let country: String
    let coordinate: Coordinate
}

extension Location {
    struct Coordinate {
        let latitude: Double
        let longitude: Double
    }
}
