//
//  BrowersAlbumViewController.swift
//  Euphoria
//
//  Created by macbook on 30.05.2021.
//

import UIKit

class BrowersAlbumViewController: UIViewController, GradientBackground {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var albums: [Album] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGradientBackground(view: view)
        
        configureCollectionView()
        
        fetchData()
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = layout()
    }
    
    private func fetchData() {
        let group = DispatchGroup()
        group.enter()
        
        APICaller.shared.getNewReleases { [weak self] (result) in
            defer {
                group.leave()
            }
            switch result {
            case.success(let model):
                self?.albums = model.albums.items
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension BrowersAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AlbumCollectionViewCell.identifier,
                for: indexPath) as? AlbumCollectionViewCell else {
            return UICollectionViewCell()
        }
        let album = albums[indexPath.row]
        cell.configure(with: NewReleasesCellViewModel(name: album.name, artWorkUrl: URL(string: album.images.first?.url ?? ""), numberOfTracks: album.total_tracks, artistName: album.artists.first?.name ?? ""))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album = albums[indexPath.row]
        if let AlbumVC = storyboard?.instantiateViewController(identifier: "AlbumViewController") as? AlbumViewController {
            AlbumVC.modalPresentationStyle = .fullScreen
            AlbumVC.album = album
            AlbumVC.albumName = album.name
            self.present(AlbumVC, animated: true, completion: nil)
        }
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment -> NSCollectionLayoutSection? in
            
            // Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            // Group
            // Vertical group inside the horizontal group
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize:
                                                                    NSCollectionLayoutSize(widthDimension: .absolute(400), heightDimension: .absolute(266)),
                                                                 subitem: item,
                                                                 count: 1)
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize:
                                                                        NSCollectionLayoutSize(widthDimension: .absolute(400), heightDimension: .absolute(266)),
                                                                     subitem: verticalGroup,
                                                                     count: 2)
            
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            
            return section
            
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 5
        layout.configuration = config
        
        return layout
    }
    
}

