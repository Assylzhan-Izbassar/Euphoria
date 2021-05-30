//
//  FavoriteCollectionViewCell.swift
//  Euphoria
//
//  Created by macbook on 14.05.2021.
//

import UIKit

class FavoriteCollectionViewCell: BaseCollectionViewCell{
    
    @IBOutlet weak var albumName: UILabel!
    
    func configure(with playlist: MyMediaPlaylistViewModel) {
        albumName.text = playlist.name
    }
}
