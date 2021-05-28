//
//  Genre.swift
//  Euphoria
//
//  Created by Амира Байжулдинова on 14.05.2021.
//

import Foundation

struct GenreResponse: Codable {
    let genres: [String]
}

struct Genre {
    var name: String
}

struct AllCategories: Codable {
    let categories: CategoryResponse
}

struct CategoryResponse: Codable {
    let items: [Category]
    let total: Int
}

struct Category: Codable {
    let id: String
    let name: String
    let icons: [GenericImage]
}


extension Genre {
    static func getSearchGenre() -> [Genre] {
        return [
            Genre(name: "All"),
            Genre(name: "Tracks"),
            Genre(name: "Artists"),
            Genre(name: "Albums")
        ]
    }
}

