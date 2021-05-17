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
                Song(name: "Non stop", artistName: "DimodZho", posterUrl: "nonstop", fileName: "DimodZho-NonStop"),
                Song(name: "Bowie", artistName: "Art of war", posterUrl: "artofwar", fileName: "Bowie-ArtofWar"),
                Song(name: "Flepsy", artistName: "Awareness", posterUrl: "poster", fileName: "Flepsy-SelfAwareness")
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
