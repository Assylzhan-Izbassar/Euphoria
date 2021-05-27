//
//  RecommendedTrackCollectionViewCell.swift
//  Euphoria
//
//  Created by macbook on 26.05.2021.
//

import UIKit

class RecommendedTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecommendedTrackCollectionViewCell"
    @IBOutlet weak var trackImg: UIImageView!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var artistName: UILabel!
    
    func configure(with viewModel: RecommendationCellViewModel) {
        trackTitleLabel.text = viewModel.name
        artistName.text = viewModel.artistName
        trackImg.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}
