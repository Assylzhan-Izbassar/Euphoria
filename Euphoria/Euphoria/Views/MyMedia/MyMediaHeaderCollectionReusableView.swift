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
    
    func configure(with title: String) {
        titleLabel.text = title
    }
    
    @IBAction func addNewPlaylist(_ sender: UIButton, section: Int) {
        switch section {
        case 0:
            MyMediaHeaderCollectionReusableView.delegate?.addNewPlaylist()
        case 1:
            break
        default:
            break
        }
    }
}
