//
//  PlayerPresenter.swift
//  Euphoria
//
//  Created by macbook on 29.05.2021.
//

import Foundation
import UIKit
import AVFoundation

protocol PlayerDataSource: AnyObject {
    var songTitle: String? { get }
    var artistName: String? { get }
    var imageURL: URL? { get }
}

final class PlayerPresenter: PlayerDataSource, PlayerViewControllerDelegate {
    var songTitle: String? {
        return currentTrack?.name
    }
    
    var artistName: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
    
    static let shared = PlayerPresenter()
    
    
    private var track: Track?
    private var tracks = [Track]()
    
    var currentTrack: Track? {
        if let track = track, tracks.isEmpty {
            return track
        } else if !tracks.isEmpty {
            return tracks.first
        }
        return nil
    }
    
    var player: AVPlayer?
    
    private init() {}
    
    func didTapBackward() {
        if tracks.isEmpty{
            player?.pause()
            player?.play()
        }
        
        else{
            
        }
    }
    
    func didTapForward() {
        if tracks.isEmpty{
            player?.pause()
        }
        
        else{
            
        }
    }
    
    func didTapPlayPause() {
        if let player = player{
            if player.timeControlStatus == .playing{
                player.pause()
            }
            
            else if player.timeControlStatus == .paused{
                player.play()
            }
        }
        
    }
    
    func startPlayer(from viewController: UIViewController, track: Track) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let playerVC = storyboard.instantiateViewController(identifier: "PlayerViewController") as? PlayerViewController {
            guard let url = URL(string: track.preview_url ?? "") else {
                return
            }
            player = AVPlayer(url: url)
            player?.volume = 0.5
            self.tracks = []
            self.track = track
            playerVC.dataSource = self
            playerVC.delegate = self
            viewController.present(playerVC, animated: true) { [weak self] () in
                self?.player?.play()
            }
        }
    }
    
    func startPlayer(from viewController: UIViewController, tracks: [Track]) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let playerVC = storyboard.instantiateViewController(identifier: "PlayerViewController") as? PlayerViewController {
            self.tracks = tracks
            self.track = nil
            playerVC.dataSource = self
            viewController.present(playerVC, animated: true, completion: nil)
        }
    }
}


