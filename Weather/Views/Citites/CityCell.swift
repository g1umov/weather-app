//
//  CityCell.swift
//  Weather
//
//  Created by Vladislav on 30.10.22.
//

import UIKit

final class CityCell: UITableViewCell {
    lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22)
        label.textColor = .lightText
        return label
    }()
    
    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 36, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(_ viewModel: CityViewModel) {
        iconView.image = UIImage(systemName: viewModel.weathercode)
        cityLabel.text = viewModel.city
        temperatureLabel.text = viewModel.temperature
    }
    
    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(iconView)
        contentView.addSubview(cityLabel)
        contentView.addSubview(temperatureLabel)
    }
    
    private func setupLayouts() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cityLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        contentView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 18)
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            iconView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            iconView.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor),
            
            cityLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            cityLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 18),
            cityLabel.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            
            temperatureLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            temperatureLabel.leadingAnchor.constraint(greaterThanOrEqualTo: cityLabel.trailingAnchor, constant: 12),
            temperatureLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            temperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
