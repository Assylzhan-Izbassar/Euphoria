//
//  APICaller.swift
//  Euphoria
//
//  Created by macbook on 25.05.2021.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    struct Constants {
        static let baseApiUrl = "https://api.spotify.com/v1"
    }
    
    private init() {}
    
    enum APIError: Error {
        case failedToGetData
    }
    public func getCurrentUserProfile(completion: @escaping (Result<User, Error>) -> Void) {
        createRequest(with: URL(string: "\(Constants.baseApiUrl)/me"), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(result)
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Private
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    private func createRequest(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void) {
        AuthManager.shared.withValidToken { (token) in
            guard let apiUrl = url else { return }
            
            var request = URLRequest(url: apiUrl)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
}
