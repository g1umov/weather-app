//
//  Endpoint.swift
//  Weather
//
//  Created by Vladislav on 01.11.22.
//

import Foundation

protocol Endpoint {
    func asURL() throws -> URL
}
