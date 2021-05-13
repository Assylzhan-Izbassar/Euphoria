//
//  IntroViewController.swift
//  Euphoria
//
//  Created by macbook on 23.04.2021.
//

import UIKit

class IntroViewController: UIViewController, GradientBackground {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setGradientBackground(view: view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let delayInSeconds = 2.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let secondVC = storyboard.instantiateViewController(identifier: "TabBarViewController")
            
            secondVC.modalPresentationStyle = .fullScreen
            
            self.present(secondVC, animated: true, completion: nil)
        }
    }
}
