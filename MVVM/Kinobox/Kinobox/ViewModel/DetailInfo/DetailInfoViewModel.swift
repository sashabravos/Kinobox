//
//  DetailInfoViewModel.swift
//  Kinobox
//
//  Created by Александра Кострова on 12.09.2023.
//

import Foundation

// MARK: - DetailInfoViewModelProtocol

protocol DetailInfoViewModelProtocol {
        
    func loadInfo(for selectedFilm: Int, view: DetailInfoView)
}

// MARK: - DetailInfoViewModel

final class DetailInfoViewModel: DetailInfoViewModelProtocol {
        
    func loadInfo(for selectedFilm: Int, view: DetailInfoView) {
        RequestManager.shared.requestFilms(requestType: .detailFilmInfo,
                                           ID: selectedFilm) { (result: Result<FilmInfo, Error>) in
            switch result {
            case .success(let film):
                DispatchQueue.main.async { [weak self] in
                    self?.configureView(with: film, view: view)
                }
            case .failure(let error):
                print("Error:", error)
            }
        }
    }
    
    private func configureView(with info: FilmInfo, view: DetailInfoView) {
        if let ratingRu = info.ratingKinopoisk,
           let ratingWorld = info.ratingImdb,
           let header = info.nameRu,
           let subHeader = info.nameOriginal,
           let description = info.description,
           let imageURL = info.posterUrl {
            
            view.configureViewElements(ratingKinopoisk: "\(ratingRu)",
                                       ratingImdb: "\(ratingWorld)",
                                       nameRu: header,
                                       nameOriginal: subHeader,
                                       description: description,
                                       year: "\(info.year)",
                                       filmLength: "\(info.filmLength)",
                                       posterUrl: URL(string: imageURL)!)
        }
    }
}
