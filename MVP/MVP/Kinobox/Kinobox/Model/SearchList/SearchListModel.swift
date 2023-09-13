//
//  SearchListModel.swift
//  Kinobox
//
//  Created by Александра Кострова on 09.09.2023.
//

import UIKit
import Alamofire

// MARK: - RequestProtocol

protocol SearchListModelRequestProtocol {
    func searchMovies<T: Decodable>(by keyword: String, completion: @escaping (Result<T, Error>) -> Void)
    func getTopMovies<T: Decodable>(completion: @escaping (Result<T, Error>) -> Void)
    func decodeData<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

final class SearchListModel: NetworkInstants, SearchListModelRequestProtocol {
    
    // MARK: - Instants
    
    lazy var sectionTitle = "Section title"
    
    // MARK: - Request methods

    func searchMovies<T: Decodable>(by keyword: String, completion: @escaping (Result<T, Error>) -> Void) {
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
    
    func getTopMovies<T: Decodable>(completion: @escaping (Result<T, Error>) -> Void) {
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
}
