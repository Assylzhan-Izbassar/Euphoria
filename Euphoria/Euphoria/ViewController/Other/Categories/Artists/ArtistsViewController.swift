//
//  ArtistsViewController.swift
//  Euphoria
//
//  Created by macbook on 31.05.2021.
//

import UIKit
import SafariServices

class ArtistsViewController: UIViewController,GradientBackground {

    @IBOutlet weak var tableView: UITableView!
    static let identifier = "ArtistsViewController"
    
    private var artists: [Artist] = []
    
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
        
        APICaller.shared.getNewReleases { (result) in
            switch result {
            case .success(let model):
                let albums = model.albums.items
                var seeds = Set<String>()
                while seeds.count < 20 {
                    if let randElement = albums.randomElement() {
                        seeds.insert(randElement.artists.first?.id ?? "")
                    }
                }
                APICaller.shared.getArtists(ids: seeds) {[weak self] (artistsResult) in
                    defer {
                        group.leave()
                    }
                    switch artistsResult {
                    case .success(let model):
                        self?.artists = model
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @IBAction func didTapBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}


extension ArtistsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArtistsTableViewCell.identifier, for: indexPath) as? ArtistsTableViewCell
        else {
            return UITableViewCell()
        }
        let artist = artists[indexPath.row]
        cell.configure(with: RecommendationCellViewModel(name: artist.genres?.first, artistName: artist.name, artworkURL: URL(string: artist.images?.first?.url ?? "")))
        
        cell.backgroundColor = UIColor.clear.withAlphaComponent(0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let artist = artists[indexPath.row]
        guard let url = URL(string: artist.external_urls["spotify"] ?? "") else {
//                make some action
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
}
