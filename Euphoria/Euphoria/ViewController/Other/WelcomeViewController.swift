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
        guard success else {
            let alert = UIAlertController(title: "Oops", message: "Something went wrong when signing in.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        if let secondVC = storyboard?.instantiateViewController(identifier: "TabBarViewController") {
            AuthManager.shared.refreshAccessToken(completion: nil)
            secondVC.modalPresentationStyle = .fullScreen
            self.present(secondVC, animated: true, completion: nil)
        }
    }
}
