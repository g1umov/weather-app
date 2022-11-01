//
//  Date + Extensions.swift
//  Weather
//
//  Created by Vladislav on 01.11.22.
//

import Foundation

extension Date {
    static var current: Date { .init() }
    
    func distance(from date: Date, only component: Calendar.Component, calendar: Calendar = .current) -> Int {
        let days1 = calendar.component(component, from: self)
        let days2 = calendar.component(component, from: date)
        return days1 - days2
    }

    func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
        return  distance(from: date, only: component) == 0
    }
}
