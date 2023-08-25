//
//  NetworkManager.swift
//  Kinobox
//
//  Created by Александра Кострова on 24.08.2023.
//

import Alamofire
import UIKit

// MARK: - RequestResultDelegate

protocol RequestResultDelegate: AnyObject {
    func getResult(_ result: String)
}

final class RequestManager {
    
    // MARK: - Instants
    
    static let shared = RequestManager()
    private init() {}
    
    weak var delegate: RequestResultDelegate?
    
    private lazy var apiKey = Constants.Keys.apiKey
    private lazy var baseURL =
    "https://kinopoiskapiunofficial.tech/api/v2.1/films/search-by-keyword?keyword"
    
    // MARK: - Public methods
    
    public func searchMovies(by keyword: String, with method: RequestButton.RequestType) {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [URLQueryItem(name: "keyword", value: keyword)]
        
        guard let url = components?.url else {
            self.delegate?.getResult("Something went wrong... \nCheck your URL")
            return
        }
        
        switch method {
        case .alamofire:
            let headers: HTTPHeaders = [
                "X-API-KEY": apiKey
            ]
            
            AF.request(url, method: .get, headers: headers).responseData { response in
                switch response.result {
                case .success(let data):
                    if let convertedString = String(data: data, encoding: .utf8) {
                        self.delegate?.getResult(convertedString)
                    } else {
                        self.delegate?.getResult("Something went wrong...\nCheck your Data type")
                    }
                case .failure(let error):
                    print("Error:\n \(error)")
                }
            }
            
        case .urlSession:
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue(apiKey, forHTTPHeaderField: "X-API-KEY")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error:\n \(error)")
                } else if let data = data {
                    let convertedString = String(data: data, encoding: .utf8)
                    self.delegate?.getResult(convertedString ?? "Something went wrong...\nCheck your Data type")
                }
            }
            task.resume()
        }
    }
}
