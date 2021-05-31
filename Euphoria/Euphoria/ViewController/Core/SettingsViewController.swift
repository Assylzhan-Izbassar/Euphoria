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
        if let profileVC = storyboard?.instantiateViewController(identifier: "ProfileViewController") as? ProfileViewController{
            profileVC.modalPresentationStyle = .fullScreen
            present(profileVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: NSLocalizedString("Sign Out", comment: ""), message: NSLocalizedString("Are you sure?", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Sign Out", comment: ""), style: .destructive, handler: {_ in
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
    
    @IBAction func didShareToFriendPressed(_ sender: UIButton) {
        let external_url = "https://github.com/Assylzhan-Izbassar/Euphoria"
        
        let vc = UIActivityViewController(activityItems: ["Check out the feeling of euphoria!", external_url], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
}
