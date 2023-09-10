//
//  DetailInfoPresenter.swift
//  Kinobox
//
//  Created by Александра Кострова on 09.09.2023.
//

import Foundation

// MARK: - DetailInfoViewProtocol

protocol DetailInfoViewProtocol: AnyObject {

    var selectedFilmID: Int? { get set }

    func configure(with model: FilmInfo)
}

// MARK: - DetailInfoPresenterProtocol

protocol DetailInfoPresenterProtocol: AnyObject {
    func setView(_ view: DetailInfoViewProtocol)
    
    func loadInfo()
}

// MARK: - DetailInfoPresenter

final class DetailInfoPresenter: DetailInfoPresenterProtocol {
    
    private weak var view: DetailInfoViewProtocol?
    private var model: DetailInfoModel?
    
    func setView(_ view: DetailInfoViewProtocol) {
        self.view = view
    }
    
    func configureView(with model: FilmInfo) {
        view?.configure(with: model)
    }
    
    func loadInfo() {
        RequestManager.shared.getFilmInfo(id: view?.selectedFilmID ?? 1) { (result: Result<FilmInfo, Error>) in
            switch result {
            case .success(let film):
                DispatchQueue.main.async { [weak self] in
                    self?.configureView(with: film)
                }
            case .failure(let error):
                print("Error:", error)
            }
        }
    }
}
