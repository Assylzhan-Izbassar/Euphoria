//
//  Album.swift
//  Euphoria
//
//  Created by macbook on 14.05.2021.
//

import Foundation

// Get a list of new ALBUM releases
struct NewReleasesResponse: Codable {
    let albums: AlbumsResponse
}

struct AlbumsResponse: Codable {
    let items: [Album]
}

struct Album: Codable {
//    var songs: [Song]
    
    let artists: [Artist]
    let album_type: String
    let available_markets: [String]
    let id: String
    let images: [GenericImage]
    let name: String
    let release_date: String
    let total_tracks: Int
}

extension Album {
    static func getAlbums() -> [Album] {
//        return [
//            Album(name: "For training", songs: [
//                Song(name: "Bowie", artistName: "Art of war", posterUrl: "artofwar", fileName: "Bowie-ArtofWar")
//            ]),
//            Album(name: "For study", songs: [
//            ]),
//            Album(name: "Sadly", songs: [
//            ]),
//            Album(name: "Dance", songs: [
//            ])
//        ]
        return []
    }
}
