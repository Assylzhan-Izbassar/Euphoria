//
//  AlbumDetailsCollectionViewCell.swift
//  Euphoria
//
//  Created by macbook on 27.05.2021.
//

import UIKit

class AlbumDetailsCollectionViewCell: UICollectionViewCell {
    static let identifier = "AlbumDetailsCollectionViewCell"
    @IBOutlet weak var albumImg: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
}
