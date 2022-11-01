//
//  ForecastDetailView.swift
//  Weather
//
//  Created by Vladislav on 31.10.22.
//

import UIKit

final class ForecastDetailView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightText
        return label
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(_ viewModel: ForecastDetailViewModel) {
        titleLabel.text = viewModel.title
        textLabel.text = viewModel.text
    }
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(textLabel)
    }
    
    private func setupLayout() {
        setupTitleLabelLayout()
        setupTextLabelLayout()
    }
    
    private func setupTitleLabelLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setupTextLabelLayout() {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
