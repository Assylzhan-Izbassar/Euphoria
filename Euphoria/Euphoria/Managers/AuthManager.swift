//
//  AuthManager.swift
//  Euphoria
//
//  Created by macbook on 25.05.2021.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    var isSigned: Bool { return true }
    private var accessToken: String? { return nil }
    private var refreshToken: String? { return nil }
    private var tokenExpirationDate: Date? { return nil }
    private var shouldRefreshToken: Bool? { return false }
    
    private init() {}
}
