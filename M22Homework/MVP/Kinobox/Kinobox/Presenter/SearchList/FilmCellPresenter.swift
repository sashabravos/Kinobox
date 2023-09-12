//
//  FilmCellPresenter.swift
//  Kinobox
//
//  Created by Александра Кострова on 09.09.2023.
//

import Foundation

// MARK: - FilmCellViewProtocol

protocol FilmCellViewProtocol: AnyObject {

    func configure(with filmModel: Film)
}

// MARK: - FilmCellPresenterProtocol

protocol FilmCellPresenterProtocol: AnyObject {
    func setView(_ view: FilmCellViewProtocol)
    
    func configureCell(with model: Film)
}

// MARK: - FilmCellPresenter

final class FilmCellPresenter: FilmCellPresenterProtocol {
    
    private weak var view: FilmCellViewProtocol?
    
    func setView(_ view: FilmCellViewProtocol) {
        self.view = view
    }
    
    func configureCell(with model: Film) {
        view?.configure(with: model)
    }
}
