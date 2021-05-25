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
        static let clientSecret = ""
    }
    
    public var signInURL: URL? {
        let baseUrl = "https://accounts.spotify.com/authorize"
        let scopes = "user-read-private&user-read-email"
        let redirectUri = "https://github.com/Assylzhan-Izbassar?tab=repositories"
        let urlString = "\(baseUrl)?response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(redirectUri)&show_dialog=TRUE"
        
        return URL(string: urlString)
    }
    
    var isSigned: Bool { return false }
    private var accessToken: String? { return nil }
    private var refreshToken: String? { return nil }
    private var tokenExpirationDate: Date? { return nil }
    private var shouldRefreshToken: Bool? { return false }
    
    private init() {}
    
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void)) {
        // Get Token
    }
    
    public func refreshAccessToken() {
        
    }
    
    private func cacheToken() {
        
    }
}
