//
//  LibraryPlaylistResponse.swift
//  Euphoria
//
//  Created by macbook on 29.05.2021.
//

import Foundation

struct LibraryPlaylistResponse: Codable {
    let href: String
    let items: [Playlist]
    let total: Int
}
