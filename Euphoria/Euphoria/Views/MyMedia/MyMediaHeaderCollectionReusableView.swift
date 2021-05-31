//
//  MyMediaHeaderCollectionReusableView.swift
//  Euphoria
//
//  Created by macbook on 29.05.2021.
//

import UIKit

protocol MyMediaHeaderCollectionReusableViewDelegate {
    func addNewPlaylist()
    func addNewAlbum()
}

class MyMediaHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "MyMediaHeaderCollectionReusableView"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    
    static var delegate: MyMediaHeaderCollectionReusableViewDelegate?
    
    func configure(with title: String) {
        titleLabel.text = title
    }
    
    @IBAction func addNewPlaylist(_ sender: UIButton) {
        if titleLabel.text == NSLocalizedString("Playlists", comment: "") {
            MyMediaHeaderCollectionReusableView.delegate?.addNewPlaylist()
        } else if titleLabel.text == NSLocalizedString("Albums", comment: ""){
            MyMediaHeaderCollectionReusableView.delegate?.addNewAlbum()
        }
    }
}
