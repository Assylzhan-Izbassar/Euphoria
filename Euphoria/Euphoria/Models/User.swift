//
//  User.swift
//  Euphoria
//
//  Created by macbook on 25.05.2021.
//

import Foundation

struct User: Codable {
    let country: String
    let display_name: String
    let explicit_content: [String : Bool]
    let external_urls: [String : String]
    let id: String
    let product: String
    let image: [GenericImage]?
}


//{
//    country = KZ;
//    "display_name" = Assylzhan;
//    "explicit_content" =     {
//        "filter_enabled" = 0;
//        "filter_locked" = 0;
//    };
//    "external_urls" =     {
//        spotify = "https://open.spotify.com/user/ijjpgwa5n9tylxg7ekyzfo7jk";
//    };
//    followers =     {
//        href = "<null>";
//        total = 0;
//    };
//    href = "https://api.spotify.com/v1/users/ijjpgwa5n9tylxg7ekyzfo7jk";
//    id = ijjpgwa5n9tylxg7ekyzfo7jk;
//    images =     (
//    );
//    product = open;
//    type = user;
//    uri = "spotify:user:ijjpgwa5n9tylxg7ekyzfo7jk";
//}
