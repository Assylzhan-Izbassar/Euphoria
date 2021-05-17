//
//  PopularCollectionViewCell.swift
//  Euphoria
//
//  Created by Амира Байжулдинова on 14.05.2021.
//

import UIKit

class PopularCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var genreName: UILabel!
    
    func configure(with genre: Genre) {
        genreName.text = genre.name
    }
}

