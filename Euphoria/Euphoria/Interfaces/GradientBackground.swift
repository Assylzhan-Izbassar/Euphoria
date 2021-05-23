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
            // 0.8784, 0.4941, 0.6941
            UIColor(red: 1, green: 0.4941, blue: 0.6941, alpha: 1).cgColor,
            UIColor(red: 0.46, green: 0.45, blue: 0.894, alpha: 1).cgColor
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
