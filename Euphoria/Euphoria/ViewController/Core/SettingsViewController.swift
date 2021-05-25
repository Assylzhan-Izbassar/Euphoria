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
}
