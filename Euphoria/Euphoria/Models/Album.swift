//
//  Album.swift
//  Euphoria
//
//  Created by macbook on 14.05.2021.
//

import Foundation

struct Album {
    var name: String
    var songs: [Song]
}

extension Album {
    static func getAlbums() -> [Album] {
        return [
            Album(name: "For training", songs: [
            ]),
            Album(name: "For study", songs: [
            ]),
            Album(name: "Sadly", songs: [
            ]),
            Album(name: "Dance", songs: [
            ])
        ]
    }
}
