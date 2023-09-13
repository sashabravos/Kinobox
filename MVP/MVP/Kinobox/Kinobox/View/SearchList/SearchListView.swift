//
//  SearchListView.swift
//  Kinobox
//
//  Created by Александра Кострова on 09.09.2023.
//

import UIKit
import SnapKit

final class SearchListView: UIViewController {
    
    // MARK: - Properties
    
    lazy var keyword = ""
    private let presenter: SearchListPresenterProtocol = SearchListPresenter()
    
    // MARK: - UI Elements
    
    private lazy var requestSearchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Введите слово для поиска"
        search.barTintColor = Constants.Color.background
        search.searchTextField.textColor = Constants.Color.darkText
        search.searchTextField.font = Constants.Font.secondaryFont
        search.searchTextField.clearButtonMode = .always
        return search
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Поиск", for: .normal)
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
        button.setTitle("Популярные фильмы", for: .normal)
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
        presenter.setView(self)
        presenter.loadTopMovies()
    }
    
    // MARK: - Private Methods
    
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
        view.endEditing(true)
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
        }
        presenter.searchButtonTapped(with: keyword)
    }
    
    @objc func popularButtonTapped() {
        view.endEditing(true)
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
        }
        presenter.popularButtonTapped()
    }
}

// MARK: - UITableViewDataSource

extension SearchListView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        presenter.titleForHeaderInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filmCell = tableView.dequeueReusableCell(
            withIdentifier: FilmCellView.identifier,
            for: indexPath) as! FilmCellView
        
        let film = presenter.getFilm(for: indexPath)
        filmCell.presenter.configureCell(with: film)
        return filmCell
    }
}

// MARK: - UITableViewDelegate

extension SearchListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFilm = presenter.getFilm(for: indexPath)
        let detailInfo = DetailInfoView()
        detailInfo.selectedFilmID = selectedFilm.filmId
        self.present(detailInfo, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension SearchListView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // search by every letter
        keyword = searchText.lowercased()
        print(keyword)
        presenter.searchButtonTapped(with: keyword)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // press search button on keyboard
        if let word = searchBar.text {
            keyword = word.lowercased()
            presenter.searchButtonTapped(with: keyword)
        }
    }
}

extension SearchListView: SearchListViewProtocol {
    
    func reloadTable() {
        tableView.reloadData()
    }
    
    func loaderStop() {
        activityIndicator.stopAnimating()
    }
}
