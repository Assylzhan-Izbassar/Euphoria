//
//  PlayerViewController.swift
//  Euphoria
//
//  Created by macbook on 29.04.2021.
//

import UIKit
import AVKit

class PlayerViewController: UIViewController, GradientBackground {
    
    @IBOutlet weak var songPoster: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var elapsedTime: UILabel!
    @IBOutlet weak var remainingTime: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    private var player = AVAudioPlayer()
    private var timer: Timer?
    private var playingIndex = 0
    
    var album: Album?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setGradientBackground(view: view)
        slider.tintColor = .white
        
        if let album = album {
            setupPlayer(with: album.songs[playingIndex])
        }
    }
    
    // method that setting up the player with url
    private func setupPlayer(with song: Song) {
        guard let url = Bundle.main.url(forResource: song.fileName, withExtension: "mp3")
        else {
            return
        }
        
        if timer == nil {
            timer = Timer(timeInterval: 0.0001, target: self, selector: #selector(updateProgressBar), userInfo: nil, repeats: true)
        }
        
        songTitle.text = song.name
        artistName.text = song.artistName
        songPoster.image = UIImage(named: song.posterUrl)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            player.prepareToPlay()
            
            // if phone is not in silence then it will be play
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    @objc private func updateProgressBar() {
        
    }
    
    @IBAction func pause(_ sender: UIButton) {
    }
    
    @IBAction func nextPressed(_ sender: UIButton) {
    }
    
    @IBAction func previousPressed(_ sender: UIButton) {
    }
    
    @IBAction func progressBar(_ sender: UISlider) {
        
    }
}

extension PlayerViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        nextPressed(nextBtn)
    }
}
