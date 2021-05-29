//
//  Playlist.swift
//  Euphoria
//
//  Created by macbook on 26.05.2021.
//

import Foundation

struct Playlist: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [GenericImage]
    let name: String
    let owner: Owner
//    let tracks: TracksResponse?
//    let type: String?
}

//{
//    collaborative = 0;
//    description = "<null>";
//    "external_urls" =     {
//        spotify = "https://open.spotify.com/playlist/5yr3KkVPxjKs2ZdhfYvEIw";
//    };
//    followers =     {
//        href = "<null>";
//        total = 0;
//    };
//    href = "https://api.spotify.com/v1/playlists/5yr3KkVPxjKs2ZdhfYvEIw";
//    id = 5yr3KkVPxjKs2ZdhfYvEIw;
//    images =     (
//    );
//    name = Dance;
//    owner =     {
//        "display_name" = Assylzhan;
//        "external_urls" =         {
//            spotify = "https://open.spotify.com/user/ijjpgwa5n9tylxg7ekyzfo7jk";
//        };
//        href = "https://api.spotify.com/v1/users/ijjpgwa5n9tylxg7ekyzfo7jk";
//        id = ijjpgwa5n9tylxg7ekyzfo7jk;
//        type = user;
//        uri = "spotify:user:ijjpgwa5n9tylxg7ekyzfo7jk";
//    };
//    "primary_color" = "<null>";
//    public = 1;
//    "snapshot_id" = MSxmYjUyMTM2MzZhM2M2YzA0ODJiY2VlZTgxOGIxZTkwNmNjZDIyMDEx;
//    tracks =     {
//        href = "https://api.spotify.com/v1/playlists/5yr3KkVPxjKs2ZdhfYvEIw/tracks";
//        items =         (
//        );
//        limit = 100;
//        next = "<null>";
//        offset = 0;
//        previous = "<null>";
//        total = 0;
//    };
//    type = playlist;
//    uri = "spotify:playlist:5yr3KkVPxjKs2ZdhfYvEIw";
//}
