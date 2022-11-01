//
//  LocationViewController.swift
//  Weather
//
//  Created by Vladislav on 24.10.22.
//

import UIKit

final class LocationViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LocationCell.self)
        return tableView
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightText
        return label
    }()
    
    private let searchController = UISearchController()

    private let presenter: LocationPresenter
    private var viewModels = [LocationViewModel]()
    
    init(presenter: LocationPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupView()
        setupLayouts()
    }
    
    private func setupView() {
        view.backgroundColor = .black
        view.addSubview(tableView)
        view.addSubview(errorLabel)
        setupSearchController()
    }
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = .white
        searchController.searchBar.searchTextField.tintColor = .white
        searchController.searchBar.searchTextField.textColor = .white
        searchController.searchBar.keyboardAppearance = .dark
    }

    private func setupLayouts() {
        setupTableViewLayout()
        setupErrorLabelLayout()
    }
    
    private func setupTableViewLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupErrorLabelLayout() {
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            errorLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor),
            errorLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }

}

extension LocationViewController: LocationPresenterViewOutput {
    func present(locations: [LocationViewModel]) {
        DispatchQueue.main.async {
            self.viewModels = locations
            self.tableView.reloadData()
            self.errorLabel.isHidden = true
        }
    }
    
    func present(error: String) {
        DispatchQueue.main.async {
            self.viewModels = []
            self.tableView.reloadData()
            self.errorLabel.text = error
            self.errorLabel.isHidden = false
        }
    }
}

extension LocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LocationCell = tableView.dequeueReusableCell(for: indexPath)
        let viewModel = viewModels[indexPath.item]
        
        cell.title = viewModel
        
        return cell
    }
}

extension LocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.selectLocation(byIndex: indexPath.item)
    }
}

extension LocationViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let inputText = searchController.searchBar.text else { return }
        
        presenter.search(inputText: inputText)
    }
}
