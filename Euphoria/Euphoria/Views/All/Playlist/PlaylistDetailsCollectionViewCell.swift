//
//  PlaylistDetailsCollectionViewCell.swift
//  Euphoria
//
//  Created by macbook on 28.05.2021.
//

import UIKit
import SDWebImage

class PlaylistDetailsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PlaylistDetailsCollectionViewCell"
    
    @IBOutlet weak var trackImg: UIImageView!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var artistName: UILabel!
    
    func configure(with viewModel: RecommendationCellViewModel) {
        trackTitle.text = viewModel.name
        artistName.text = viewModel.artistName
        trackImg.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}
