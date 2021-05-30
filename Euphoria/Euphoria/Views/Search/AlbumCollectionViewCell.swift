//
//  AlbumCollectionViewCell.swift
//  Euphoria
//
//  Created by macbook on 30.05.2021.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    static let identifier = "AlbumCollectionViewCell"
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var creator: UILabel!
    
    func configure(with viewModel: NewReleasesCellViewModel) {
        decorate()
        title.text = viewModel.name
        creator.text = viewModel.artistName
        poster.sd_setImage(with: viewModel.artWorkUrl, completed: nil)
    }
    
    private func decorate() {
        poster.layer.masksToBounds = false
        poster.layer.cornerRadius = poster.frame.size.width/4
        poster.clipsToBounds = true
    }
}
