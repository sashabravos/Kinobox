//
//  ViewModelRequestManager.swift
//  Kinobox
//
//  Created by Александра Кострова on 24.08.2023.
//

import UIKit
import Alamofire

final class RequestManager {
    
    // MARK: - Instants
    
    static let shared = RequestManager()
    
    private init() {}
    
    private lazy var apiKey = Constants.Keys.apiKey
    private lazy var filmsURL = Constants.Link.filmsURL
    private lazy var detailURL = Constants.Link.detailURL
    private lazy var topFilmsURL = Constants.Link.topFilmsURL
    private lazy var searchByKeywordURL = Constants.Link.searchByKeywordURL
    
    enum RequestType {
        case search
        case topFilms
        case detailFilmInfo
    }
    
    // MARK: - Public methods
    
    public func requestFilms<T: Decodable>(requestType: RequestType,
                                           keyword: String? = nil,
                                           ID: Int? = nil,
                                           completion: @escaping (Result<T, Error>) -> Void) {
        var currentURL = ""
        
        switch requestType {
        case .search:
            currentURL = searchByKeywordURL
        case .topFilms:
            currentURL = topFilmsURL
        case .detailFilmInfo:
            guard let id = ID else { return }
            currentURL = detailURL + "\(id)"
        }
        
        var components = URLComponents(string: currentURL)
        
        if requestType == .search {
            guard let word = keyword else { return }
            components?.queryItems = [URLQueryItem(name: "keyword", value: word)]
        } else if requestType == .topFilms {
            components?.queryItems = [URLQueryItem(name: "type", value: "TOP_100_POPULAR_FILMS")]
        }
        
        guard let url = components?.url else {
            print("Something went wrong... \nCheck your URL")
            return
        }
        
        let headers: HTTPHeaders = [
            "X-API-KEY": apiKey
        ]
        
        AF.request(url, method: .get, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try self.decodeData(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Private methods
    
    /// Universal function to decode
    private func decodeData<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
