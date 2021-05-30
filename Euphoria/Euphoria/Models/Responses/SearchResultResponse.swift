//
//  SearchResultResponse.swift
//  Euphoria
//
//  Created by macbook on 30.05.2021.
//

import Foundation

struct SearchResultResponse: Codable {
    let albums: SearchAlbumResponse
    let artists: SearchArtistsResponse
    let tracks: SearchTracksResponse
}

struct SearchAlbumResponse: Codable {
    let items: [Album]
}

struct SearchArtistsResponse: Codable {
    let items: [Artist]
}

struct SearchTracksResponse: Codable {
    let items: [Track]
}
