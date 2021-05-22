//
//  TabBarViewController.swift
//  Euphoria
//
//  Created by macbook on 23.04.2021.
//

import UIKit

class TabBarViewController: UITabBarController, GradientBackground {
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground(view: self.view)
    }
}
