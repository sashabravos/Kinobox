//
//  NetworkManager.swift
//  Kinobox
//
//  Created by Александра Кострова on 24.08.2023.
//

import Alamofire
import UIKit

final class RequestManager {
    
    // MARK: - Instants
    
    static let shared = RequestManager()
    private init() {}
    
    private lazy var apiKey = Constants.Keys.apiKey
    private lazy var filmsURL = Constants.Link.filmsURL
    private lazy var detailURL = Constants.Link.detailURL
    private lazy var searchByKeywordURL = Constants.Link.searchByKeywordURL
    private lazy var topFilmsURL = Constants.Link.topFilmsURL
    
    // MARK: - Public methods
    
    public func searchMovies<T: Decodable>(by keyword: String, completion: @escaping (Result<T, Error>) -> Void) {
        var components = URLComponents(string: searchByKeywordURL)
        components?.queryItems = [URLQueryItem(name: "keyword", value: keyword)]
        
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
    
    public func getTopMovies<T: Decodable>(completion: @escaping (Result<T, Error>) -> Void) {
        var components = URLComponents(string: topFilmsURL)
        components?.queryItems = [URLQueryItem(name: "type", value: "TOP_100_POPULAR_FILMS")]
        
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
    
    public func getFilmInfo(id: Int, completion: @escaping (Result<FilmInfo, Error>) -> Void) {
        let components = URLComponents(string: detailURL + "\(id)")
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
                    let decodedData = try self.decodeData(FilmInfo.self, from: data)
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
