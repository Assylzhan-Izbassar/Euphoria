//
//  PlaylistCollectionViewCell.swift
//  Euphoria
//
//  Created by macbook on 28.05.2021.
//

import UIKit

class PlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "PlaylistCollectionViewCell"
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var creator: UILabel!
    
    func configure(with viewModel: FeaturedPlaylistCellViewModel) {
        title.text = viewModel.name
        creator.text = viewModel.creatorName
        image.sd_setImage(with: viewModel.imageUrl, completed: nil)
    }
}
