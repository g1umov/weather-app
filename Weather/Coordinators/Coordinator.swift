//
//  Coordinator.swift
//  Weather
//
//  Created by Vladislav on 31.10.22.
//

import UIKit

protocol Coordinator {
    var viewController: UIViewController { get }
    
    func configure()
}
