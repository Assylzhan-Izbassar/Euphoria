//
//  FeaturedPlaylistResponse.swift
//  Euphoria
//
//  Created by macbook on 26.05.2021.
//

import Foundation

struct FeaturedPlaylistResponse: Codable {
    let playlists: PlaylistResponse
}

struct PlaylistResponse: Codable {
    let items: [Playlist]
}

struct Playlist: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [GenericImage]
    let name: String
    let owner: Owner
}

struct Owner: Codable {
    let display_name: String
    let external_urls: [String: String]
    let id: String
}
