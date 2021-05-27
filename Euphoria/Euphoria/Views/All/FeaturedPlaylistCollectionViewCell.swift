//
//  FeaturedPlaylistCollectionViewCell.swift
//  Euphoria
//
//  Created by macbook on 26.05.2021.
//

import UIKit
import SDWebImage

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturedPlaylistCollectionViewCell"
    
    @IBOutlet weak var playlistImage: UIImageView!
    @IBOutlet weak var playlistLabel: UILabel!
    @IBOutlet weak var playlistCreator: UILabel!
    
    func configure(with viewModel: FeaturedPlaylistCellViewModel) {
        playlistLabel.text = viewModel.name
        playlistCreator.text = viewModel.creatorName
        playlistImage.sd_setImage(with: viewModel.imageUrl, completed: nil)
    }
}
