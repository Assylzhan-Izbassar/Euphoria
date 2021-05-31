//
//  NewReleaseCollectionViewCell.swift
//  Euphoria
//
//  Created by macbook on 26.05.2021.
//

import UIKit
import SDWebImage

class NewReleaseCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewReleaseCollectionViewCell"
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var tracksCount: UILabel!
    
    func configure(with viewModel: NewReleasesCellViewModel) {
        albumTitle.text = viewModel.name
        artistName.text = viewModel.artistName
        tracksCount.text = NSLocalizedString("Tracks: \(viewModel.numberOfTracks)", comment: "")
        albumImage.sd_setImage(with: viewModel.artWorkUrl, completed: nil)
    }
}
