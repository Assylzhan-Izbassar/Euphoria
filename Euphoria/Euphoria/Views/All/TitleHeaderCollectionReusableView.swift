//
//  TitleHeaderCollectionReusableView.swift
//  Euphoria
//
//  Created by macbook on 28.05.2021.
//

import UIKit

class TitleHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "TitleHeaderCollectionReusableView"
    
    @IBOutlet weak var headerTitle: UILabel!
    
    func configure(with title: String) {
        headerTitle.text = title
    }
}
