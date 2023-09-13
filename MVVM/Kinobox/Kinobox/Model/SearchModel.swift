//
//  SearchModel.swift
//  Kinobox
//
//  Created by Александра Кострова on 27.08.2023.
//

import Foundation

struct SearchModel: Decodable {
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
