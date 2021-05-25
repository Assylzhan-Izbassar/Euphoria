//
//  AuthManager.swift
//  Euphoria
//
//  Created by macbook on 25.05.2021.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    struct Constants {
        static let clientID = "6c5a44a75683482f8a66daef1d6a5880"
        static let clientSecret = "aa80c6da267b4f178cc42445096fef2e"
        static let tokenAPIUrl = "https://accounts.spotify.com/api/token"
    }
    
    private var refreshingToken = false
    
    public var signInURL: URL? {
        let baseUrl = "https://accounts.spotify.com/authorize"
        let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
        let redirectUri = "https://github.com/Assylzhan-Izbassar?tab=repositories"
        let urlString = "\(baseUrl)?response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(redirectUri)&show_dialog=TRUE"
        
        return URL(string: urlString)
    }
    
    var isSigned: Bool { return accessToken != nil }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expiration_date") as? Date
    }
    
    private var shouldRefreshToken: Bool? {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) > expirationDate
    }
    
    private init() {}
    
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void)) {
        // Get Token
        guard let url = URL(string: Constants.tokenAPIUrl) else { return }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: "https://github.com/Assylzhan-Izbassar?tab=repositories")
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Something went wrong in exchangeCodeForToken method, AuthManager")
            completion(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
//                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                print("json is \(json)")
                
                self?.cacheToken(result: result)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        
        task.resume()
    }
    
    private var onRefreshBlocks = [(String) -> Void]()
    
    public func withValidToken(completion: @escaping (String) -> Void) {
        guard !refreshingToken else {
            // Append the completion
            onRefreshBlocks.append(completion)
            return
        }
        if let shouldRefreshToken = self.shouldRefreshToken {
            if shouldRefreshToken {
                // Refresh the token
                refreshAccessToken { [weak self] (success) in
                    if let token = self?.accessToken, success {
                        completion(token)
                    }
                }
            } else if let token = accessToken {
                completion(token)
            }
        }
    }
    
    public func refreshAccessToken(completion: ((Bool) -> Void)?) {
        
        guard !refreshingToken else {
            return
        }
        
        if let shouldRefreshToken = self.shouldRefreshToken {
            guard shouldRefreshToken else {
                completion?(true)
                return
            }
        }
        
        guard let refreshToken = self.refreshToken else {
            return
        }
        
        // refresh the token
        guard let url = URL(string: Constants.tokenAPIUrl) else { return }
        
        refreshingToken = true
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Something went wrong in exchangeCodeForToken method, AuthManager")
            completion?(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            self?.refreshingToken = false
            guard let data = data, error == nil else {
                completion?(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
//                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                print("json is \(json)")
                self?.onRefreshBlocks.forEach { $0(result.access_token) }
                self?.onRefreshBlocks.removeAll()
                self?.cacheToken(result: result)
                completion?(true)
            } catch {
                print(error.localizedDescription)
                completion?(false)
            }
        }
        
        task.resume()
    }
    
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expiration_date")
        
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
    }
}
