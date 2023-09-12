//
//  DetailInfoModel.swift
//  Kinobox
//
//  Created by Александра Кострова on 09.09.2023.
//

import UIKit
import Alamofire

// MARK: - RequestProtocol

protocol DetailInfoModelRequestProtocol {
    func getFilmInfo(id: Int, completion: @escaping (Result<FilmInfo, Error>) -> Void)
    func decodeData<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}
final class DetailInfoModel: NetworkInstants, DetailInfoModelRequestProtocol {
    
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
}
