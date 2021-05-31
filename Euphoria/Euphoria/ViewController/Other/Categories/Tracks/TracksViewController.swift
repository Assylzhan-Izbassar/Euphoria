//
//  TracksViewController.swift
//  Euphoria
//
//  Created by macbook on 30.05.2021.
//

import UIKit

class TracksViewController: UIViewController, GradientBackground {
    
    @IBOutlet weak var tableView: UITableView!
    static let identifier = "TracksViewController"
    
    private var tracks: [Track] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground(view: view)
        
        configureTableView()
        
        fetchData()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear.withAlphaComponent(0)
    }
    
    private func fetchData() {
        let group = DispatchGroup()
        group.enter()
        
        APICaller.shared.getRecommendedGenres(completion: { result in
            switch result {
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                
                while seeds.count < 5 {
                    if let randElement = genres.randomElement() {
                        seeds.insert(randElement)
                    }
                }
                APICaller.shared.getRecommendations(genres: seeds) {[weak self] recommendedResult in
                    defer {
                        group.leave()
                    }
                    switch recommendedResult {
                    case .success(let model):
                        self?.tracks = model.tracks
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
        
        group.notify(queue: .main) { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension TracksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TracksTableViewCell", for: indexPath) as? TracksTableViewCell
        else {
            return UITableViewCell()
        }
        let track = tracks[indexPath.row]
        cell.configure(with: RecommendationCellViewModel(name: track.name, artistName: track.artists.first?.name ?? "No name", artworkURL: URL(string: track.album?.images.first?.url ?? "")))
        
        cell.backgroundColor = UIColor.clear.withAlphaComponent(0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let track = tracks[indexPath.row]
//        
//        var trackWithAlbum: [Track] = []
//        trackWithAlbum.append(track)
        
        if let playerVC = storyboard?.instantiateViewController(identifier: "PlayerViewController") as? PlayerViewController {
            playerVC.startingIndex = indexPath.row
            playerVC.tracks = tracks
            present(playerVC, animated: true, completion: nil)
        }
    }
}
