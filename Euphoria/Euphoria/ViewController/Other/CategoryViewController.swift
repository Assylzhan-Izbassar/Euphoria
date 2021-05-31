//
//  CategoryViewController.swift
//  Euphoria
//
//  Created by macbook on 28.05.2021.
//

import UIKit

class CategoryViewController: UIViewController, GradientBackground {
    
    var category: Category?
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var playlists = [Playlist]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGradientBackground(view: view)
        headerTitle.text = category!.name
        configureCollectionView()
        
        fetchData()
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
    }
    
    private func fetchData() {
        APICaller.shared.getCategoryPlaylist(category: category!) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let models):
                    self?.playlists = models
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistCollectionViewCell.identifier, for: indexPath) as! PlaylistCollectionViewCell
        let item = playlists[indexPath.row]
        cell.configure(with: FeaturedPlaylistCellViewModel(name: item.name, imageUrl: URL(string: item.images.first?.url ?? ""), creatorName: item.owner.display_name))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let playlistVC = storyboard?.instantiateViewController(identifier: "PlaylistViewController") as? PlaylistViewController {
            playlistVC.modalPresentationStyle = .fullScreen
            playlistVC.playlist = playlists[indexPath.row]
            self.present(playlistVC, animated: true, completion: nil)
        }
    }
}

