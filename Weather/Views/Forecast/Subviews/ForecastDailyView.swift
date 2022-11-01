//
//  ForecastDailyView.swift
//  Weather
//
//  Created by Vladislav on 01.11.22.
//

import UIKit

final class ForecastDailyView: UIView {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 32
        return stackView
    }()
    
    private lazy var weedaysStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var weathercodeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var minTemperatureStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var maxTemperatureStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.spacing = 8
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(_ viewModel: ForecastDailyViewModel) {
        cleanStackViews()
        fillWeekdays(viewModel.weekdays)
        fillWeathercodes(viewModel.weathercodes)
        fillMinTemperatures(viewModel.minTemperature)
        fillMaxTemperatures(viewModel.maxTemperature)
    }
    
    private func setupView() {
        addSubview(stackView)
        stackView.addArrangedSubview(weedaysStackView)
        stackView.addArrangedSubview(weathercodeStackView)
        stackView.addArrangedSubview(minTemperatureStackView)
        stackView.addArrangedSubview(maxTemperatureStackView)
    }
    
    private func setupLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func cleanStackViews() {
        weedaysStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        weathercodeStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        minTemperatureStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        maxTemperatureStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    private func fillWeekdays(_ weekdays: [String]) {
        weekdays.forEach {
            let label = UILabel()
            label.textColor = .white
            label.text = $0
            weedaysStackView.addArrangedSubview(label)
        }
    }
    
    private func fillWeathercodes(_ weathercodes: [Forecast.Weathercode]) {
        weathercodes.forEach {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .white
            imageView.image = UIImage(weathercode: $0)
            weathercodeStackView.addArrangedSubview(imageView)
        }
    }
    
    private func fillMinTemperatures(_ values: [String]) {
        values.forEach {
            let label = UILabel()
            label.textColor = .white
            label.text = $0
            minTemperatureStackView.addArrangedSubview(label)
        }
    }
    
    private func fillMaxTemperatures(_ values: [String]) {
        values.forEach {
            let label = UILabel()
            label.textColor = .white
            label.text = $0
            maxTemperatureStackView.addArrangedSubview(label)
        }
    }
    
}
