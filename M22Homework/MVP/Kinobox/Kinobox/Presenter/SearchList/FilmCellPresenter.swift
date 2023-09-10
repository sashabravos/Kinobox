//
//  FilmCellPresenter.swift
//  Kinobox
//
//  Created by Александра Кострова on 09.09.2023.
//

import Foundation

// MARK: - FilmCellViewProtocol

protocol FilmCellViewProtocol: AnyObject {

    func configure(with model: Film)
}

// MARK: - FilmCellPresenterProtocol

protocol FilmCellPresenterProtocol: AnyObject {
    func setView(_ view: FilmCellViewProtocol)
}

// MARK: - FilmCellPresenter

final class FilmCellPresenter: FilmCellPresenterProtocol {
    
    private weak var view: FilmCellViewProtocol?
    private var model: FilmCellModel?
    
    func setView(_ view: FilmCellViewProtocol) {
        self.view = view
    }
    
    func configureCell(with model: Film) {
        view?.configure(with: model)
    }
}
