//
//  FavoriteCollectionViewCell.swift
//  Euphoria
//
//  Created by macbook on 14.05.2021.
//

import UIKit

class FavoriteCollectionViewCell: BaseCollectionViewCell{
    
    @IBOutlet weak var albumName: UILabel!
    
    func setup(with album: Album) {
        albumName.text = album.name
    }
}
