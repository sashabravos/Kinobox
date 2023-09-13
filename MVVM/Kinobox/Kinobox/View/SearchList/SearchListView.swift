//
//  SearchListView.swift
//  Kinobox
//
//  Created by Александра Кострова on 12.09.2023.
//

import UIKit
import SnapKit

final class SearchListView: UIViewController {
    
    // MARK: - Properties
    
    private lazy var viewModel: SearchListViewModelProtocol = SearchListViewModel()
    
    // MARK: - UI Elements
    
    private lazy var requestSearchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = viewModel.placeholder
        search.barTintColor = Constants.Color.background
        search.searchTextField.textColor = Constants.Color.darkText
        search.searchTextField.font = Constants.Font.secondaryFont
        search.searchTextField.clearButtonMode = .always
        return search
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle(viewModel.titleForRequestButton, for: .normal)
        button.setTitleColor(Constants.Color.lightText, for: .normal)
        button.backgroundColor = Constants.Color.searchButton
        button.titleLabel?.font = Constants.Font.primaryFont
        button.titleLabel?.textAlignment = .center
        button.layer.borderColor = Constants.Color.borderLine
        button.layer.borderWidth = Constants.BorderLine.frameWidth
        button.layer.cornerRadius = Constants.CornerRadius.big
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var topFilmsButton: UIButton = {
        let button = UIButton()
        button.setTitle(viewModel.titleForTopFilmsButton, for: .normal)
        button.setTitleColor(Constants.Color.lightText, for: .normal)
        button.backgroundColor = Constants.Color.topFilmsButton
        button.titleLabel?.font = Constants.Font.primaryFont
        button.titleLabel?.textAlignment = .center
        button.layer.borderColor = Constants.Color.borderLine
        button.layer.borderWidth = Constants.BorderLine.frameWidth
        button.layer.cornerRadius = Constants.CornerRadius.big
        button.addTarget(self, action: #selector(popularButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = Constants.Color.background
        tableView.register(FilmCellView.self, forCellReuseIdentifier: FilmCellView.identifier)
        return tableView
    }()
    
    private lazy var activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubviews()
        layoutSubViews()
        viewModelInstants()
        popularButtonTapped()
        viewModel.loadTopMovies()
    }
    
    // MARK: - Private Methods
    
    private func viewModelInstants() {
        
        viewModel.updateView = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.loaderStart = {
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.startAnimating()
            }
        }
        
        viewModel.loaderStop = {
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
            }
        }
        
        viewModel.hideKeyboard = { [weak self] in
            self?.view.endEditing(true)
        }
    }
    
    private func setSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        requestSearchBar.delegate = self
        
        view.backgroundColor = Constants.Color.background
        
        [requestSearchBar, searchButton, topFilmsButton, tableView, activityIndicator].forEach {
            view.addSubview($0)
        }
    }
    
    private func layoutSubViews() {
        requestSearchBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.topMargin.equalToSuperview().offset(Constants.Constraints.bigVerticalGap)
        }
        
        searchButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(requestSearchBar.snp.bottom).offset(Constants.Constraints.smallVerticalGap)
            make.width.greaterThanOrEqualTo(Constants.Constraints.searchButtonWidth)
        }
        
        topFilmsButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(searchButton.snp.bottom).offset(Constants.Constraints.smallVerticalGap)
            make.width.greaterThanOrEqualTo(Constants.Constraints.topFilmsButtonWidth)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topFilmsButton.snp.bottom).offset(Constants.Constraints.smallVerticalGap)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(tableView.snp.center)
        }
    }
    
    // MARK: - Buttons Actions
    
    @objc func searchButtonTapped() {
        viewModel.searchButtonTapped(with: viewModel.keyword ?? "")
    }
    
    @objc func popularButtonTapped() {
        viewModel.popularButtonTapped()
    }
}

// MARK: - UITableViewDataSource

extension SearchListView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getNumberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.getTitleForHeaderInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filmCell = tableView.dequeueReusableCell(
            withIdentifier: FilmCellView.identifier,
            for: indexPath) as! FilmCellView
        
        let film = viewModel.getFilm(for: indexPath)
        viewModel.configureCell(with: film, cell: filmCell)
        return filmCell
    }
}

// MARK: - UITableViewDelegate

extension SearchListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailView = DetailInfoView()
        viewModel.cellTapped(indexPath, view: detailView)
        viewModel.showDetailScreen = { [weak self] in
            self?.present(detailView, animated: true)
        }
    }
}

// MARK: - UISearchBarDelegate

extension SearchListView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // search by every letter
        viewModel.keyword = searchText.lowercased()
        viewModel.searchFilmByLetter(with: viewModel.keyword!)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // press search button on keyboard
        if let word = searchBar.text {
            viewModel.keyword = word.lowercased()
            viewModel.searchButtonTapped(with: viewModel.keyword!)
        }
    }
}
