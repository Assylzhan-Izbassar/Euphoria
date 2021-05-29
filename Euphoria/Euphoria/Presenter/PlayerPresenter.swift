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

final class PlayerPresenter {

    static let shared = PlayerPresenter()
    
    private var track: Track?
    private var tracks = [Track]()
    
    var currentTrack: Track? {
        if let track = track, tracks.isEmpty {
            return track
        } else if let player = self.playerQueue, !tracks.isEmpty {
            var i = 0
            if let item = player.currentItem {
                guard
                    let index = player.items().firstIndex(of: item)
                else {
                    return nil
                }
                i = index
            }
            return tracks[i]
        }
        return nil
    }
    
    // players
    var player: AVPlayer?
    var playerQueue: AVQueuePlayer?
    
    private init() {}
    
    func startPlayer(from viewController: UIViewController, track: Track) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let playerVC = storyboard.instantiateViewController(identifier: "PlayerViewController") as? PlayerViewController {
            guard let url = URL(string: track.preview_url ?? "") else {
                return
            }
            player = AVPlayer(url: url)
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
            
            let items: [AVPlayerItem] = tracks.compactMap({
                guard
                    let url = URL(string: $0.preview_url ?? "")
                else {
                    return nil
                }
                return AVPlayerItem(url: url)
            })
            playerQueue = AVQueuePlayer(items: items)
            playerQueue?.play()
            
            playerVC.dataSource = self
            playerVC.delegate = self
            viewController.present(playerVC, animated: true, completion: nil)
        }
    }
}

extension PlayerPresenter: PlayerDataSource {
    var songTitle: String? {
        return currentTrack?.name
    }
    
    var artistName: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
}

extension PlayerPresenter: PlayerViewControllerDelegate {
    func didTapBackward() {
        if tracks.isEmpty{
            player?.pause()
            player?.play()
        } else if let firstItem = playerQueue?.items().first {
            playerQueue?.pause()
            playerQueue?.removeAllItems()
            playerQueue = AVQueuePlayer(items: [firstItem])
            playerQueue?.play()
        }
    }
    
    func didTapForward() {
        if tracks.isEmpty{
            player?.pause()
        } else if let player = playerQueue {
            player.advanceToNextItem()
        }
    }
    
    func didTapPlayPause() {
        if let player = player {
            if player.timeControlStatus == .playing{
                player.pause()
            } else if player.timeControlStatus == .paused{
                player.play()
            }
        } else if let player = playerQueue {
            if player.timeControlStatus == .playing{
                player.pause()
            } else if player.timeControlStatus == .paused{
                player.play()
            }
        }
    }
}

