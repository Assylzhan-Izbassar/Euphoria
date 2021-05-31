//
//  ProfileViewController.swift
//  Euphoria
//
//  Created by macbook on 25.05.2021.
//

import UIKit

class ProfileViewController: UIViewController, GradientBackground {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var counryName: UILabel!
    @IBOutlet weak var productName: UILabel!
    
    private var _name: String = ""
    private var _country: String = ""
    private var _product: String = ""
    private var _image: UIImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground(view: view)
        decorate()
        
        APICaller.shared.getCurrentUserProfile { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
//                    print(model.display_name)
                    self?.configure(with: model.display_name, country: model.country, productName: model.product, imgURL: model.image?.first?.url ?? "")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func decorate() {
        profileImage.layer.masksToBounds = false
        profileImage.layer.cornerRadius = profileImage.frame.size.width/4
        profileImage.clipsToBounds = true
    }
    
    private func configure(with name: String, country: String, productName: String, imgURL: String) {
        self.name.text  = name
        counryName.text = country
        self.productName.text = productName
        profileImage.sd_setImage(with: URL(string: imgURL), placeholderImage: UIImage(named: "ellipse"), context: nil)
    }
    
    @IBAction func didBackPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
