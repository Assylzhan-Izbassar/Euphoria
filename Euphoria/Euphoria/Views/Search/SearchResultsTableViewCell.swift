//
//  SearchResultCollectionViewCell.swift
//  Euphoria
//
//  Created by macbook on 28.05.2021.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {
    static let identifier = "SearchResultsTableViewCell"
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var creator: UILabel!
    
    func configure(with viewModel: RecommendationCellViewModel) {
        decorate()
        title.text = viewModel.name
        creator.text = viewModel.artistName
        poster.sd_setImage(with: viewModel.artworkURL, placeholderImage: UIImage(named: "ellipse"), completed: nil)
    }
    
    private func decorate() {
        poster.layer.masksToBounds = false
        poster.layer.cornerRadius = poster.frame.height/4
        poster.clipsToBounds = true
    }
}
