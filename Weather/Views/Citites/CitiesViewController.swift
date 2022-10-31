//
//  CitiesViewController.swift
//  Weather
//
//  Created by Vladislav on 30.10.22.
//

import UIKit

final class CitiesViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.refreshControl = refreshControl
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 58
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CityCell.self)
        return tableView
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightText
        return label
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(updateForecasts), for: .valueChanged)
        return refreshControl
    }()
    
    private let presenter: CitiesPresenter
    private var dataSource: [CityViewModel] = []
    
    init(presenter: CitiesPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayouts()
        presenter.prepareCities()
    }
    
    private func setupView() {
        view.backgroundColor = .lightGray
        view.addSubview(tableView)
        view.addSubview(errorLabel)
    }
    
    private func setupLayouts() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            errorLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            errorLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor),
            errorLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    @objc private func updateForecasts() {
        presenter.updateForecasts()
    }
}

extension CitiesViewController: CitiesPresenterViewOutput {
    func present(viewModels: [CityViewModel]) {
        DispatchQueue.main.async {
            self.dataSource = viewModels
            self.tableView.reloadData()
            self.errorLabel.isHidden = true
        }
    }
    
    func update(viewModels: [CityViewModel]) {
        DispatchQueue.main.async {
            self.dataSource = viewModels
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            self.errorLabel.isHidden = true
        }
    }
    
    func insert(viewModel: CityViewModel) {
        DispatchQueue.main.async {
            self.dataSource.append(viewModel)
            self.tableView.reloadData()
        }
    }
    
    func present(error: String) {
        DispatchQueue.main.async {
            self.errorLabel.isHidden = false
            self.errorLabel.text = error
        }
    }
}

extension CitiesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CityCell = tableView.dequeueReusableCell(for: indexPath)
        let viewModel = dataSource[indexPath.item]
        
        cell.selectionStyle = .none
        cell.setup(viewModel)
        
        return cell
    }
}

extension CitiesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.selectCity(index: indexPath.item)
    }
}
