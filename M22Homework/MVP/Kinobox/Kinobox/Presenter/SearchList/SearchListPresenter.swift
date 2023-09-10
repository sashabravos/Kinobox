//
//  SearchListPresenter.swift
//  Kinobox
//
//  Created by Александра Кострова on 09.09.2023.
//

import UIKit

// MARK: - SearchListViewProtocol

protocol SearchListViewProtocol: AnyObject {
    
    var keyword: String { get set }
    
    var searchBar: UISearchBar { get }
    var requestButton: UIButton { get }
    var topMovieButton: UIButton { get }
    
    func reloadTable()
    func viewEndEditing()
    
    func loaderStart()
    func loaderStop()
}

// MARK: - SearchListPresenterProtocol

protocol SearchListPresenterProtocol: AnyObject {
    
    /// Set view
    func setView(_ view: SearchListViewProtocol)
    
    /// Load top 250 movies
    func loadTopMovies()
    
    /// Search button action
    func searchButtonTapped()
    
    /// Popular button action
    func popularButtonTapped()
    
    /// Update tableView info
    func updateTableView(with films: [Film],
                         sender: UIButton)
    /// Set value to numberOfRowsInSection
    func numberOfRowsInSection() -> Int
    
    /// Set value to titleForHeaderInSection
    func titleForHeaderInSection() -> String?
    
    func getFilm(for indexPath: IndexPath) -> Film?
    
}

// MARK: - SearchListPresenter

final class SearchListPresenter: SearchListPresenterProtocol {
    
    private weak var view: SearchListViewProtocol?
    private var model: SearchListModel?
    
    func setView(_ view: SearchListViewProtocol) {
        self.view = view
    }
    
    func loadTopMovies() {
        getTopMovies()
    }
    
    func searchButtonTapped() {
        getSearchResult()
    }
    
    func popularButtonTapped() {
        getTopMovies()
    }
    
    func updateTableView(with films: [Film],
                         sender: UIButton) {
        updateInfo(with: films, sender: sender)
    }
    
    func numberOfRowsInSection() -> Int {
        model?.filmsArray.count ?? 0
    }
    
    func titleForHeaderInSection() -> String? {
        model?.sectionTitle
    }
    
    func getFilm(for indexPath: IndexPath) -> Film? {
        model?.filmsArray[indexPath.row]
        
    }
    
    private func getSearchResult() {
        
        view?.viewEndEditing()
        
        DispatchQueue.main.async { [weak self] in
            self?.view?.loaderStart()
        }
        
        if let word = view?.searchBar.text {
            view?.keyword = word.lowercased()
        }
        
        RequestManager.shared.searchMovies(by: view!.keyword) { (result: Result<SearchFilmModel, Error>) in
            switch result {
            case .success(let searchModel):
                let film = searchModel.films
                
                DispatchQueue.main.async { [weak self] in
                    self?.updateInfo(with: film,
                                     sender: (self?.view?.requestButton)!)
                }
            case .failure(let error):
                print("Error:", error)
            }
        }
    }
    
    private func getTopMovies() {
        view?.viewEndEditing()
        
        DispatchQueue.main.async { [weak self] in
            self?.view?.loaderStart()
        }
        
        RequestManager.shared.getTopMovies { (result: Result<SearchFilmModel, Error>) in
            switch result {
            case .success(let searchModel):
                let film = searchModel.films
                
                DispatchQueue.main.async { [weak self] in
                    self?.updateInfo(with: film,
                                     sender: (self?.view?.topMovieButton)!)
                }
            case .failure(let error):
                print("Error:", error)
            }
        }
    }
    
    private func updateInfo(with films: [Film], sender: UIButton) {
        if sender == view?.requestButton {
            model!.sectionTitle = "Поиск по запросу: \(view!.keyword.capitalized)"
        } else {
            model?.sectionTitle = "Популярные фильмы"
        }
        
        model?.filmsArray.removeAll()
        model?.filmsArray.append(contentsOf: films)
        view?.reloadTable()
        view?.loaderStop()
    }
}
