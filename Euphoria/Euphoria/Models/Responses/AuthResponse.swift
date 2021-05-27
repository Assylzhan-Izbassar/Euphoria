//
//  AuthResponse.swift
//  Euphoria
//
//  Created by macbook on 25.05.2021.
//

import Foundation

struct AuthResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}
