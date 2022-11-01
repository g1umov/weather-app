//
//  UITableView + Extensions.swift
//  Weather
//
//  Created by Vladislav on 24.10.22.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Unable to init cell with identifier \(T.identifier)")
        }
        
        return cell
    }
    
    func register<T: UITableViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.identifier)
    }
}
