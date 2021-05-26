//
//  User.swift
//  Euphoria
//
//  Created by macbook on 25.05.2021.
//

import Foundation

struct User: Codable {
    let country: String
    let display_name: String
    let explicit_content: [String : Bool]
    let external_urls: [String : String]
    let id: String
    let product: String
    let image: [GenericImage]?
}

struct Owner: Codable {
    let display_name: String
    let external_urls: [String: String]
    let id: String
}
