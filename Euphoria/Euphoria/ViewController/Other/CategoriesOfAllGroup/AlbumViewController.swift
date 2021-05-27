//
//  AlbumViewController.swift
//  Euphoria
//
//  Created by macbook on 27.05.2021.
//

import UIKit

class AlbumViewController: UIViewController {

    var album: Album?
    
    @IBOutlet weak var albumTitleLabel: UILabel!
    
    var albumName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albumTitleLabel.text = albumName
        
        fetchAlbumDetail()
    }
    
    private func fetchAlbumDetail() {
        if let album = album {
            APICaller.shared.getAlbumDetails(for: album) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
