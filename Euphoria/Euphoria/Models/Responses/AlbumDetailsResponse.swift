//
//  AlbumDetailsResponse.swift
//  Euphoria
//
//  Created by macbook on 27.05.2021.
//

import Foundation

struct AlbumDetailsResponse: Codable {
    let album_type: String
    let artists: [Artist]
    let available_markets: [String]
    let external_urls: [String : String]
    let id: String
    let images: [GenericImage]
    let label: String
    let name: String
    let popularity: Int
    let tracks: TracksResponse
    let type: String
}
