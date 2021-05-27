//
//  PlaylistDetailsResponse.swift
//  Euphoria
//
//  Created by macbook on 27.05.2021.
//

import Foundation

struct PlaylistDetailsResponse: Codable {
    let description: String
    let external_urls: [String : String]
    let id: String
    let images: [GenericImage]
    let name: String
//    let owner: Owner
    let tracks: PlaylistTracksResponse
}

struct PlaylistTracksResponse: Codable {
    let items: [PlaylistItem]
}

struct PlaylistItem: Codable {
    let track: Track
}
