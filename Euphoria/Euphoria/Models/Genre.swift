//
//  Genre.swift
//  Euphoria
//
//  Created by Амира Байжулдинова on 14.05.2021.
//

import Foundation

struct Genre {
    var name: String
}

extension Genre {
    static func getGenre() -> [Genre] {
        return [
            Genre(name: "All genres"),
            Genre(name: "Alternative"),
            Genre(name: "Blues"),
            Genre(name: "Eastern"),
            Genre(name: "Dubstep"),
            Genre(name: "Jazz"),
            Genre(name: "K-pop"),
            Genre(name: "Pop music"),
            Genre(name: "Dance"),
            Genre(name: "Hip-hop"),
            Genre(name: "Electronics"),
            Genre(name: "Workout")
        ]
    }
}

