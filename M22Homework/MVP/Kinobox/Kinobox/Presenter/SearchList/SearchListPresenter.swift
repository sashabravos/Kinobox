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
    
    func reloadTable()
    func loaderStop()
}

// MARK: - SearchListPresenterProtocol

protocol SearchListPresenterProtocol: AnyObject {
    
    var filmsArray: [Film] { get set }
    
    /// Set view
    func setView(_ view: SearchListViewProtocol)
    
    /// Load top 100 movies
    func loadTopMovies()
    
    /// Search button action
    func searchButtonTapped(with keyword: String)
    
    /// Popular button action
    func popularButtonTapped()
    
    /// Set value to numberOfRowsInSection
    func numberOfRowsInSection() -> Int
    
    /// Set value to titleForHeaderInSection
    func titleForHeaderInSection() -> String
    
    func getFilm(for indexPath: IndexPath) -> Film
    
    func updateTableView(with films: [Film])
    
}

// MARK: - SearchListPresenter

final class SearchListPresenter: SearchListPresenterProtocol {
    
    private weak var view: SearchListViewProtocol?
    let model = SearchListModel()
    
    var filmsArray: [Film] = []
    
    func setView(_ view: SearchListViewProtocol) {
        self.view = view
    }
    
    func loadTopMovies() {
        getTopMovies()
    }
    
    func searchButtonTapped(with keyword: String) {
        getSearchResult(by: keyword)
    }
    
    func popularButtonTapped() {
        getTopMovies()
    }
    
    func updateTableView(with films: [Film]) {
        updateInfo(with: films)
    }
    
    func numberOfRowsInSection() -> Int {
        return filmsArray.count
    }
    
    func titleForHeaderInSection() -> String {
        return model.sectionTitle
    }
    
    func getFilm(for indexPath: IndexPath) -> Film {
        return filmsArray[indexPath.row]
    }
    
    func updateInfo(with films: [Film]) {
        filmsArray.removeAll()
        filmsArray.append(contentsOf: films)
        view?.reloadTable()
        view?.loaderStop()
    }
    
    // MARK: - Network service with model
    
    private func getSearchResult(by keyword: String) {
        
        model.searchMovies(by: keyword) { (result: Result<SearchModel, Error>) in
            switch result {
            case .success(let searchModel):
                let film = searchModel.films
                
                DispatchQueue.main.async { [weak self] in
                    guard let strongView = self?.view else {
                        return
                    }
                    self?.model.sectionTitle = "Поиск по запросу: \(strongView.keyword.capitalized)"
                    self?.updateInfo(with: film)
                }
            case .failure(let error):
                print("Error:", error)
            }
        }
    }
    
    private func getTopMovies() {
        model.getTopMovies { (result: Result<SearchModel, Error>) in
            switch result {
            case .success(let searchModel):
                let film = searchModel.films
                
                DispatchQueue.main.async { [weak self] in
                    self?.model.sectionTitle = "Популярные фильмы: "
                    self?.updateInfo(with: film)
                }
            case .failure(let error):
                print("Error:", error)
            }
        }
    }
}
