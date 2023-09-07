//
//  SearchViewController.swift
//  Kinobox
//
//  Created by Александра Кострова on 24.08.2023.
//

import UIKit
import SnapKit
import Alamofire

final class SearchViewController: UIViewController, SearchViewDelegate {
    
    // MARK: - Instants
    
    private lazy var keyword = ""
    private lazy var searchView = SearchView()
    private let requestManager = RequestManager.shared
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popularButtonTapped()
        addButtonsActions()
        searchView.delegate = self
        setMyView(searchView, self.view)
    }
    
    // MARK: - Buttons Actions
    
    private func addButtonsActions() {
        searchView.searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        searchView.topFilmsButton.addTarget(self, action: #selector(popularButtonTapped), for: .touchUpInside)
    }
    
    @objc func searchButtonTapped() {
        view.endEditing(true)
        DispatchQueue.main.async { [weak self] in
            self?.searchView.activityIndicator.startAnimating()
        }
        
        if let word = searchView.requestSearchBar.text {
            keyword = word.lowercased()
        }
        
        requestManager.searchMovies(by: keyword) { (result: Result<SearchModel, Error>) in
            switch result {
            case .success(let searchModel):
                let film = searchModel.films
                
                DispatchQueue.main.async { [weak self] in
                    self?.updateTableView(with: film,
                                          sender: (self?.searchView.searchButton)!)
                }
            case .failure(let error):
                print("Error:", error)
            }
        }
    }
    
    @objc func popularButtonTapped() {
        view.endEditing(true)
        DispatchQueue.main.async { [weak self] in
            self?.searchView.activityIndicator.startAnimating()
        }
        
        requestManager.getTopMovies { (result: Result<SearchModel, Error>) in
            switch result {
            case .success(let searchModel):
                let film = searchModel.films
                
                DispatchQueue.main.async { [weak self] in
                    self?.updateTableView(with: film,
                                          sender: (self?.searchView.topFilmsButton)!)
                }
            case .failure(let error):
                print("Error:", error)
            }
        }
    }
    // MARK: - Data separation
    
    private func updateTableView(with films: [Film],
                                 sender: UIButton) {
        if sender == searchView.searchButton {
            self.searchView.sectionTitle = "Поиск по запросу: \(keyword.capitalized)"
        } else {
            self.searchView.sectionTitle = "Популярные фильмы"
        }
        
        searchView.filmsArray.removeAll()
        searchView.filmsArray.append(contentsOf: films)
        searchView.tableView.reloadData()
        searchView.activityIndicator.stopAnimating()
    }
}
