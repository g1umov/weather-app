//
//  City+CoreDataProperties.swift
//  Weather
//
//  Created by Vladislav on 30.10.22.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var name: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var state: String?
    @NSManaged public var country: String?

}

extension City : Identifiable {

}
