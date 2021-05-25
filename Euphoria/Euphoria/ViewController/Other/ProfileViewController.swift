//
//  ProfileViewController.swift
//  Euphoria
//
//  Created by macbook on 25.05.2021.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        APICaller.shared.getCurrentUserProfile { (result) in
            switch result {
            case .success(_):
                    break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
