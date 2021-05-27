//
//  PlaylistViewController.swift
//  Euphoria
//
//  Created by macbook on 27.05.2021.
//

import UIKit

class PlaylistViewController: UIViewController {
    
    var playlist: Playlist?

    @IBOutlet weak var playlistTitleLabel: UILabel!
    
    var playlistTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playlistTitleLabel.text = playlistTitle
        
        fetchPlaylistDetail()
    }
    
    private func fetchPlaylistDetail() {
        if let playlist = playlist {
            APICaller.shared.getPlaylistDetails(for: playlist) { (result) in
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
