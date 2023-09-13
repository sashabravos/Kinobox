//
//  SearchListViewModel.swift
//  Kinobox
//
//  Created by Александра Кострова on 12.09.2023.
//

import UIKit

// MARK: - SearchListViewModelProtocol

protocol SearchListViewModelProtocol {
    
    var keyword: String? { get set }
    var sectionTitle: String { get set }
    var placeholder: String { get }
    var titleForRequestButton: String { get }
    var titleForTopFilmsButton: String { get }
    
    var filmsArray: [Film] { get set }
    
    var updateView: (() -> Void)? { get set }
    var loaderStart: (() -> Void)? { get set }
    var loaderStop: (() -> Void)? { get set }
    var hideKeyboard: (() -> Void)? { get set }
    var showDetailScreen: (() -> Void)? { get set }

    /// Load top 100 movies
    func loadTopMovies()
    
    func getTitleForHeaderInSection() -> String
    func getNumberOfRowsInSection() -> Int
    func searchButtonTapped(with keyword: String)
    func popularButtonTapped()
    func searchFilmByLetter(with letter: String)
    func configureCell(with film: Film, cell: FilmCellView)
    func cellTapped(_ index: IndexPath, view: DetailInfoView)
    
    func getFilm(for indexPath: IndexPath) -> Film
}

// MARK: - SearchListViewModel

final class SearchListViewModel: SearchListViewModelProtocol {
    
    private var model: SearchModel?
    private lazy var detailViewModel: DetailInfoViewModelProtocol = DetailInfoViewModel()

    var keyword: String?
    lazy var sectionTitle = "Популярные фильмы: "
    lazy var placeholder = "Введите слово для поиска"
    lazy var titleForRequestButton = "Поиск"
    lazy var titleForTopFilmsButton = "Популярные фильмы"
    
    lazy var filmsArray: [Film] = []

    var updateView: (() -> Void)?
    var loaderStart: (() -> Void)?
    var loaderStop: (() -> Void)?
    var hideKeyboard: (() -> Void)?
    var showDetailScreen: (() -> Void)?
    
    func getTitleForHeaderInSection() -> String {
        return sectionTitle
    }
    
    func getNumberOfRowsInSection() -> Int {
        return filmsArray.count
    }
    
    func loadTopMovies() {
        getTopMovies()
    }
    
    func searchButtonTapped(with keyword: String) {
        hideKeyboard?()
        loaderStart?()
        getSearchResult(by: keyword)
    }
    
    func searchFilmByLetter(with letter: String) {
        loaderStart?()
        getSearchResult(by: letter)
    }
    
    func popularButtonTapped() {
        hideKeyboard?()
        loaderStart?()
        getTopMovies()
    }
    
    func configureCell(with film: Film, cell: FilmCellView) {
        if let name = film.nameRu,
           let url = film.posterUrl {
            cell.configure(fileName: name, posterURL: URL(string: url)!)
        }
    }
    
    func cellTapped(_ index: IndexPath, view: DetailInfoView) {
        let selectedFilm = getFilm(for: index)
        if let selectedFilmID = selectedFilm.filmId {
            detailViewModel.loadInfo(for: selectedFilmID, view: view)
        }
        showDetailScreen?()
    }
 
    func getFilm(for indexPath: IndexPath) -> Film {
        return filmsArray[indexPath.row]
    }
    
    func updateInfo(with films: [Film]) {
        filmsArray.removeAll()
        filmsArray.append(contentsOf: films)
        updateView?()
        loaderStop?()
    }
    
    // MARK: - ViewModelRequestManager
    
    private func getSearchResult(by keyword: String) {
        
        RequestManager.shared.requestFilms(requestType: .search,
                                           keyword: keyword) { (result: Result<SearchModel, Error>) in
            switch result {
            case .success(let searchModel):
                let film = searchModel.films
                
                DispatchQueue.main.async { [weak self] in
                    self?.sectionTitle = "Поиск по запросу: \(keyword.capitalized)"
                    self?.updateInfo(with: film)
                }
            case .failure(let error):
                print("Error:", error)
            }
        }
    }
    
    private func getTopMovies() {
        RequestManager.shared.requestFilms(requestType: .topFilms) { (result: Result<SearchModel, Error>) in
            switch result {
            case .success(let searchModel):
                let film = searchModel.films
                DispatchQueue.main.async { [weak self] in
                    self?.sectionTitle = "Популярные фильмы: "
                    self?.updateInfo(with: film)
                }
            case .failure(let error):
                print("Error:", error)
            }
        }
    }
}
