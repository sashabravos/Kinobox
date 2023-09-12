//
//  NetworkInstants.swift
//  Kinobox
//
//  Created by Александра Кострова on 12.09.2023.
//

import Foundation

open class NetworkInstants {
    var apiKey = Constants.Keys.apiKey
    var filmsURL = Constants.Link.filmsURL
    var detailURL = Constants.Link.detailURL
    var topFilmsURL = Constants.Link.topFilmsURL
    var searchByKeywordURL = Constants.Link.searchByKeywordURL
        
    /// Universal function to decode
    public func decodeData<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
