//
//  WelcomeViewController.swift
//  Euphoria
//
//  Created by macbook on 25.05.2021.
//

import UIKit

class WelcomeViewController: UIViewController, GradientBackground {
    
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground(view: self.view)
        
        signInBtn.clipsToBounds = true
        signInBtn.layer.cornerRadius = signInBtn.frame.height / 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as? AuthViewController
        
        destVC?.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
    }
    
    private func handleSignIn(success: Bool) {
        // Log user in or yell at them for error
    }
}
