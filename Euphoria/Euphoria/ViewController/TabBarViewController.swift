//
//  TabBarViewController.swift
//  Euphoria
//
//  Created by macbook on 23.04.2021.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    let customTabBarView: UIView = {
        
        let view = UIView(frame: .zero)
        
        // to make the cornerRadius of customTabBarView
        view.backgroundColor = .white
        view.layer.cornerRadius = 35.0
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
     
        // to make the shadow of coustmeTabBarView
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -8.0)
        view.layer.shadowOpacity = 0.12
        view.layer.shadowRadius = 10.0
         
        return view
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        addCustomTabBarView()
//        hideTabBarBorders()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customTabBarView.frame = tabBar.frame
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var newSafeArea = UIEdgeInsets()

        // Adjust the safe area to the height of the bottom views.
        newSafeArea.bottom += customTabBarView.bounds.size.height

        // Adjust the safe area insets of the
        // embedded child view controller.
        self.children.forEach({$0.additionalSafeAreaInsets = newSafeArea})
    }
    
    private func addCustomTabBarView() {
        //
        customTabBarView.frame = tabBar.frame
        view.addSubview(customTabBarView)
        view.bringSubviewToFront(self.tabBar)
    }
    
    func hideTabBarBorders()  {
        let tabBar = self.tabBar
        tabBar.backgroundImage = UIImage.from(color: .clear)
        tabBar.shadowImage = UIImage()
        tabBar.clipsToBounds = true

    }
}


extension UIImage {
    
    static func from(color: UIColor) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img!
    }
}
