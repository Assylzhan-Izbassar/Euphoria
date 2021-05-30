//
//  SettingsViewController.swift
//  Euphoria
//
//  Created by macbook on 29.04.2021.
//

import UIKit

class SettingsViewController: UIViewController, GradientBackground {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setGradientBackground(view: view)
    }
    @IBAction func profilePressed(_ sender: UIButton) {
        let vc = ProfileViewController()
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: {_ in
            AuthManager.shared.signOut { [weak self](signedOut) in
                if signedOut {
                    DispatchQueue.main.async {
                        if let welcomeVC = self?.storyboard?.instantiateViewController(identifier: "WelcomeViewController") {
                            welcomeVC.modalPresentationStyle = .fullScreen
                            self?.present(welcomeVC, animated: false, completion: {
                                if let parentVC = self?.parent as? TabBarViewController {
                                    parentVC.selectedIndex = 0
                                }
                            })
                        }
                    }
                }
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
}
