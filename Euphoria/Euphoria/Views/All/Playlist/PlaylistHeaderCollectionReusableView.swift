//
//  PlaylistHeaderCollectionReusableView.swift
//  Euphoria
//
//  Created by macbook on 28.05.2021.
//

import UIKit
import SDWebImage

final class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "PlaylistHeaderCollectionReusableView"
    
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var playlistDescription: UILabel!
    @IBOutlet weak var creator: UILabel!
    
    func configure(with viewModel: PlaylistHeaderViewModel) {
        title.text = viewModel.title
        playlistDescription.text = viewModel.playlistDescription
        creator.text = viewModel.creatorName
        headerImage.sd_setImage(with: viewModel.imageUrl, completed: nil)
    }
    
    @IBAction func playBtnPressed(_ sender: UIButton) {
        // Play the Playlist)
    }
}
