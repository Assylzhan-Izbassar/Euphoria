//
//  TracksCollectionViewCell.swift
//  Euphoria
//
//  Created by macbook on 30.05.2021.
//

import UIKit

class TracksTableViewCell: UITableViewCell {
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artistName: UILabel!
    
    func configure(with viewModel: RecommendationCellViewModel) {
        decorate()
        title.text = viewModel.name
        artistName.text = viewModel.artistName
        poster.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
    
    private func decorate() {
        poster.layer.masksToBounds = false
        poster.layer.cornerRadius = poster.frame.size.width/4
        poster.clipsToBounds = true
    }
}
