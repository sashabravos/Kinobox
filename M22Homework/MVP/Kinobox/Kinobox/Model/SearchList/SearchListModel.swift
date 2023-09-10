//
//  SearchListModel.swift
//  Kinobox
//
//  Created by Александра Кострова on 09.09.2023.
//

import Foundation

struct SearchListModel {
    lazy var filmsArray = [Film]()
    lazy var sectionTitle = "Section title"
    let searchFilmModel: SearchFilmModel
}

struct SearchFilmModel: Decodable {
    let keyword: String?
    let pagesCount: Int?
    let films: [Film]
    let searchFilmsCountResult: Int?
}

struct Film: Decodable {
    let filmId: Int?
    let nameRu: String?
    let nameEn: String?
    let type: String?
    let year: String?
    let description: String?
    let filmLength: String?
    let rating: String?
    let ratingVoteCount: Int?
    let posterUrl: String?
    let posterUrlPreview: String?
}

struct FilmInfo: Decodable {
    let nameRu: String?
    let nameOriginal: String?
    let posterUrl: String?
    let ratingKinopoisk: Float?
    let ratingImdb: Float?
    let year: Int
    let filmLength: Int
    let description: String?
}
