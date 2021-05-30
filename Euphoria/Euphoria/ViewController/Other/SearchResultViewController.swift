//
//  SearchResultViewController.swift
//  Euphoria
//
//  Created by macbook on 28.05.2021.
//

import UIKit

class SearchResultViewController: UIViewController, GradientBackground {

    @IBOutlet weak var tableView: UITableView!
    private var sections: [SearchSection] = []
    var searchedString: String?
    
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
        APICaller.shared.search(with: searchedString!) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let models):
                    self?.configure(models: models)
                    self?.tableView.isHidden = (self?.sections.isEmpty ?? (0 != 0))
                    self?.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func configure(models result: [SearchResult]) {
        let artists = result.filter({
            switch $0 {
            case .artist:
                return true
            default:
                return false
            }
        })
        let albums = result.filter({
            switch $0 {
            case .album:
                return true
            default:
                return false
            }
        })
        let tracks = result.filter({
            switch $0 {
            case .track:
                return true
            default:
                return false
            }
        })
        sections = [
            SearchSection(title: "Artists", results: artists),
            SearchSection(title: "Tracks", results: tracks),
            SearchSection(title: "Albums", results: albums)
        ]
    }

    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultsTableViewCell") as? SearchResultsTableViewCell
        else {
            return UITableViewCell()
        }
        
        let result = sections[indexPath.section].results[indexPath.row]
        
        switch result {
        case .album(let model):
            cell.configure(with: RecommendationCellViewModel(name: model.name, artistName: model.artists.first?.name, artworkURL: URL(string: model.images.first?.url ?? "")))
        case .artist(let model):
            cell.backgroundColor = .white
        case .track(let model):
            cell.configure(with: RecommendationCellViewModel(name: model.name, artistName: model.artists.first?.name, artworkURL: URL(string: model.album?.images.first?.url ?? "")))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = sections[indexPath.section].results[indexPath.row]
        
        switch result {
        case .album(let model):
            if let albumVC = storyboard?.instantiateViewController(identifier: "AlbumViewController") as? AlbumViewController {
                albumVC.album = model
                albumVC.modalPresentationStyle = .fullScreen
                self.present(albumVC, animated: true, completion: nil)
            }
        case .artist(let model):
            break
        case .track(let model):
            var trackWithAlbum: [Track] = []
            trackWithAlbum.append(model)
            
            if let playerVC = storyboard?.instantiateViewController(identifier: "PlayerViewController") as? PlayerViewController {
                playerVC.tracks = trackWithAlbum
                present(playerVC, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red: 255/255, green: 150/255, blue: 178/255, alpha: 1.0)
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
}
