//
//  PlaylistDetailsCollectionViewCell.swift
//  Euphoria
//
//  Created by macbook on 28.05.2021.
//

import UIKit

class PlaylistDetailsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PlaylistDetailsCollectionViewCell"
    
    @IBOutlet weak var trackImg: UIImageView!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var artistName: NSLayoutConstraint!
    
}
