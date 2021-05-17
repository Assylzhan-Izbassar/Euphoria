//
//  GradientBackground.swift
//  Euphoria
//
//  Created by macbook on 23.04.2021.
//

import UIKit

protocol GradientBackground {
    func setGradientBackground(view: UIView!)
}

extension GradientBackground {
    func setGradientBackground(view: UIView!) {
        let layer0 = CAGradientLayer()

        layer0.colors = [
          UIColor(red: 1, green: 0.494, blue: 0.702, alpha: 1).cgColor,
          UIColor(red: 0, green: 0.04, blue: 1, alpha: 0.49).cgColor
        ]
        
        layer0.frame = view.frame
        layer0.position = view.center

        view.layer.insertSublayer(layer0, at: 0)
    }
    
    func setRounded(image: UIImageView) {
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.cornerRadius = image.frame.height / 2
        image.clipsToBounds = true
    }
}
