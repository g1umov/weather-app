//
//  ForecastDetailsView.swift
//  Weather
//
//  Created by Vladislav on 31.10.22.
//

import UIKit

final class ForecastDetailsView: UIView {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
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
    
    func setup(_ viewModels: [ForecastDetailViewModel]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        viewModels.forEach {
            let detailView = ForecastDetailView()
            detailView.setup($0)
            stackView.addArrangedSubview(detailView)
        }
    }
    
    private func setupView() {
        addSubview(stackView)
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
    
}
