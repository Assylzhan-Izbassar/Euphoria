//
//  TabBarViewController.swift
//  Euphoria
//
//  Created by macbook on 23.05.2021.
//

import UIKit

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        makeRoundedTabBar()
        
        self.tabBar.unselectedItemTintColor = UIColor(red: 255/255.0, green: 150/255.0, blue: 178/255.0, alpha: 1.0)
    }
    
    private func makeRoundedTabBar() {
        let transperentBlackColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)

        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        transperentBlackColor.setFill()
        UIRectFill(rect)

        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            tabBar.backgroundImage = image
        }

        UIGraphicsEndImageContext()
    }
}
