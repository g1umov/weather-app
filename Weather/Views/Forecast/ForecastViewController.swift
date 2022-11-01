//
//  ForecastViewController.swift
//  Weather
//
//  Created by Vladislav on 31.10.22.
//

import UIKit

final class ForecastViewController: UIViewController {
    private lazy var scrollView = UIScrollView()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        let insets = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 16, trailing: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = insets
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var headerView = ForecastHeaderView()
    private lazy var dailyForecastView = ForecastDailyView()
    private lazy var detailsView = ForecastDetailsView()
    
    private let presenter: ForecastPresenter
    
    init(presenter: ForecastPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupView()
        setupLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewValues()
    }
    
    private func setupView() {
        view.backgroundColor = .black
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(headerView)
        stackView.addArrangedSubview(dailyForecastView)
        stackView.addArrangedSubview(detailsView)
    }
    
    private func setupLayout() {
        setupScrollViewLayout()
        setupStackViewLayout()
    }
    
    private func setupScrollViewLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupStackViewLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupViewValues() {
        headerView.setup(presenter.header)
        dailyForecastView.setup(presenter.daily)
        detailsView.setup(presenter.details)
    }
    
}
