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
    @IBOutlet weak var collectionView: UICollectionView!
    
    var playlistTitle = ""
    private var viewModels =  [RecommendationCellViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playlistTitleLabel.text = playlistTitle
        configureCollectionView()
        fetchPlaylistDetail()
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = layout()
        collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
    }
    
    private func fetchPlaylistDetail() {
        if let playlist = playlist {
            APICaller.shared.getPlaylistDetails(for: playlist) { [weak self] (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        self?.viewModels = model.tracks.items.compactMap({
                            return RecommendationCellViewModel(
                                name: $0.track.name,
                                artistName: $0.track.artists.first?.name ?? "No name",
                                artworkURL: URL(string: $0.track.album?.images.first?.url ?? ""))
                        })
                        self?.collectionView.reloadData()
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


extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistDetailsCollectionViewCell.identifier, for: indexPath) as! PlaylistDetailsCollectionViewCell
        
        cell.configure(with: viewModels[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier,
                for: indexPath) as? PlaylistHeaderCollectionReusableView,
              kind == UICollectionView.elementKindSectionHeader
        else {
            return UICollectionReusableView()
        }
        let headerModel = PlaylistHeaderViewModel(
            title: playlist?.name,
            creatorName: playlist?.owner.display_name,
            playlistDescription: playlist?.description,
            imageUrl: URL(string: playlist?.images.first?.url ?? ""))
        header.configure(with: headerModel)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // Play song
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment -> NSCollectionLayoutSection? in
            // Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            // Group
            let group = NSCollectionLayoutGroup.vertical(layoutSize:
                                                            NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(90)),
                                                         subitem: item,
                                                         count: 1)
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            
            // Needed for collection header
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(436)),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
            ]
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 8
        layout.configuration = config
        
        return layout
    }
}
