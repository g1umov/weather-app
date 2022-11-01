//
//  ForecastHeaderView.swift
//  Weather
//
//  Created by Vladislav on 31.10.22.
//

import UIKit

final class ForecastHeaderView: UIView {
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var weathercodeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = .lightText
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 38, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(_ viewModel: ForecastHeaderViewModel) {
        cityLabel.text = viewModel.city
        weathercodeLabel.text = viewModel.weathercode
        temperatureLabel.text = viewModel.temperature
    }
    
    private func setupView() {
        addSubview(cityLabel)
        addSubview(weathercodeLabel)
        addSubview(temperatureLabel)
    }
    
    private func setupLayout() {
        setupCityLabelLayout()
        setupWeathercodeLabelLayout()
        setupTemperatureLayout()
    }
    
    private func setupCityLabelLayout() {
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: topAnchor),
            cityLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            cityLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setupWeathercodeLabelLayout() {
        weathercodeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weathercodeLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 18),
            weathercodeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            weathercodeLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setupTemperatureLayout() {
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        NSLayoutConstraint.activate([
            temperatureLabel.topAnchor.constraint(equalTo: weathercodeLabel.bottomAnchor, constant: 26),
            temperatureLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            temperatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            temperatureLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
