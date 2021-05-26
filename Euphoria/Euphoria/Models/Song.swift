//
//  Song.swift
//  Euphoria
//
//  Created by macbook on 14.05.2021.
//

import Foundation

struct Track: Codable {
    let album: Album
    let artists: [Artist]
    let available_markets: [String]
    let disc_number: Int
    let duration_ms: Int
    let explicit: Bool
    let external_urls: [String:String]
    let id: String
    let name: String
    let popularity: Int
}

struct Song: Codable {
    var name: String
    var artistName: String
    var posterUrl: String
    var fileName: String
}
