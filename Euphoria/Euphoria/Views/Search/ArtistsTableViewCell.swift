//
//  ArtistsTableViewCell.swift
//  Euphoria
//
//  Created by macbook on 31.05.2021.
//

import UIKit

class ArtistsTableViewCell: UITableViewCell {
    
    static let identifier = "ArtistsTableViewCell"

    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artistGenre: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with viewModel: RecommendationCellViewModel) {
        decorate()
        artistName.text = viewModel.artistName
        artistGenre.text = viewModel.name
        artistImage.sd_setImage(with: viewModel.artworkURL, placeholderImage: UIImage(named: "ellipse"), completed: nil)
    }
    
    private func decorate() {
        artistImage.layer.masksToBounds = false
        artistImage.layer.cornerRadius = artistImage.frame.height/4
        artistImage.clipsToBounds = true
    }
}
