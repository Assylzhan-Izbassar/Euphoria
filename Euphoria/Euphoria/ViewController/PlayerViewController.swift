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
    @IBOutlet weak var playPauseBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var previousBtn: UIButton!
    
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
            setRounded(image: songPoster)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        play()
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stop()
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    // MARK: - Setup the Player
    
    // method that setting up the player with url
    private func setupPlayer(with song: Song) {
        guard let url = Bundle.main.url(forResource: song.fileName, withExtension: "mp3")
        else {
            return
        }
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(updateProgressBar), userInfo: nil, repeats: true)
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
    
    // MARK: - Player Actions
    
    @objc func updateProgressBar() {
        slider.value = Float(player.currentTime)
        
        elapsedTime.text = getFormattedTime(timeInterval: player.currentTime)
        
        let remTime = player.duration - player.currentTime
        remainingTime.text = getFormattedTime(timeInterval: remTime)
    }
    
    private func getFormattedTime(timeInterval: TimeInterval) -> String {
        let mins = timeInterval / 60
        let secs = timeInterval.truncatingRemainder(dividingBy: 60)
        
        let timeFormatter = NumberFormatter()
        timeFormatter.minimumIntegerDigits = 2
        timeFormatter.minimumFractionDigits = 0
        timeFormatter.roundingMode = .down
        
        guard let minsString = timeFormatter.string(from: NSNumber(value: mins)), let secsString = timeFormatter.string(from: NSNumber(value: secs)) else {
            return "00:00"
        }
        
        return "\(minsString):\(secsString)"
    }
    
    // helper functions that we call from outside
    func play() {
        slider.value = 0.0
        slider.maximumValue = Float(player.duration)
        player.play()
        setPlayPauseIcon(isPlaying: player.isPlaying)
    }
    
    func stop() {
        player.stop()
        timer?.invalidate()
        timer = nil
    }
    
    private func setPlayPauseIcon(isPlaying: Bool) {
//        let config = UIImage.SymbolConfiguration(pointSize: 120)
        
        // ! here we also should change
        playPauseBtn.setImage(UIImage(named: isPlaying ? "pause" : "pause"), for: .normal)
    }
    
    @IBAction func pause(_ sender: UIButton) {
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
        setPlayPauseIcon(isPlaying: player.isPlaying)
    }
    
    @IBAction func nextPressed(_ sender: UIButton) {
        
        playingIndex += 1
        
        if let album = album {
            if playingIndex >= album.songs.count {
                playingIndex = 0
            }
            setupPlayer(with: album.songs[playingIndex])
            play()
            setPlayPauseIcon(isPlaying: player.isPlaying)
        }
    }
    
    @IBAction func previousPressed(_ sender: UIButton) {
        
        playingIndex -= 1
        
        if let album = album {
            if playingIndex < 0 {
                playingIndex = album.songs.count - 1
            }
            setupPlayer(with: album.songs[playingIndex])
            play()
            setPlayPauseIcon(isPlaying: player.isPlaying)
        }
    }
    
    @IBAction func progressBar(_ sender: UISlider) {
        player.currentTime = Float64(sender.value)
    }
    
    @IBAction func back(_ sender: UIButton) {
        if let parentVC = self.parent as? TabBarViewController {
            parentVC.selectedIndex = 2
        }
    }
}

// MARK: - Extensions

extension PlayerViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        nextPressed(nextBtn)
    }
}
