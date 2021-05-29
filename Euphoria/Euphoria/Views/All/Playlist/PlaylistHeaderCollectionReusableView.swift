//
//  PlaylistHeaderCollectionReusableView.swift
//  Euphoria
//
//  Created by macbook on 28.05.2021.
//

import UIKit
import SDWebImage

protocol PlaylistHeaderCollectionReusableViewDelegate: AnyObject  {
    func playlistHeaderCollectionReusableViewDelegateDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView)
}

final class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "PlaylistHeaderCollectionReusableView"
    
    weak var delegate: PlaylistHeaderCollectionReusableViewDelegate?
    
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var playlistDescription: UILabel!
    @IBOutlet weak var creator: UILabel!
    
    func configure(with viewModel: PlaylistHeaderViewModel) {
        title.text = viewModel.title
        playlistDescription.text = viewModel.playlistDescription
        creator.text = viewModel.creatorName
        headerImage.sd_setImage(with: viewModel.imageUrl, placeholderImage: UIImage(named: "ellipse"), completed: nil)
    }
    
    @IBAction func playBtnPressed(_ sender: UIButton) {
        // Play the Playlist
        delegate?.playlistHeaderCollectionReusableViewDelegateDidTapPlayAll(self)
    }
}
