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
        title.text = viewModel.name
        creator.text = viewModel.artistName
        poster.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}
