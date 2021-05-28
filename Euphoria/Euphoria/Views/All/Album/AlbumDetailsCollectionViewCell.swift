//
//  AlbumDetailsCollectionViewCell.swift
//  Euphoria
//
//  Created by macbook on 27.05.2021.
//

import UIKit

class AlbumDetailsCollectionViewCell: UICollectionViewCell, GradientBackground {
    static let identifier = "AlbumDetailsCollectionViewCell"
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!

    func configure(with viewModel: AlbumDetailsCellViewModel) {
        trackName.text = viewModel.name
        artistName.text = viewModel.artistName
    }
}
