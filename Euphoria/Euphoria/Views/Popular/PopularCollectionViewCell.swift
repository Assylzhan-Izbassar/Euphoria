//
//  PopularCollectionViewCell.swift
//  Euphoria
//
//  Created by Амира Байжулдинова on 14.05.2021.
//

import UIKit

class PopularCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet weak var genreName: UILabel!
    
    func configure(with genre: Category) {
        genreName.text = genre.name
    }
}
