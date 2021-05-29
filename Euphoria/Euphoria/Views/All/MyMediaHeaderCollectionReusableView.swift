//
//  MyMediaHeaderCollectionReusableView.swift
//  Euphoria
//
//  Created by macbook on 29.05.2021.
//

import UIKit

protocol MyMediaHeaderCollectionReusableViewDelegate {
    func addNewPlaylist()
}

class MyMediaHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "MyMediaHeaderCollectionReusableView"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    
    static var delegate: MyMediaHeaderCollectionReusableViewDelegate?
    
    func configure(with title: String, section: Int) {
        titleLabel.text = title
        if section == 1 {
            addBtn.isHidden = true
        }
    }
    
    @IBAction func addNewPlaylist(_ sender: UIButton) {
        MyMediaHeaderCollectionReusableView.delegate?.addNewPlaylist()
    }
}
