//
//  PlaylistViewController.swift
//  Euphoria
//
//  Created by macbook on 27.05.2021.
//

import UIKit

class PlaylistViewController: UIViewController, GradientBackground {
    
    var playlist: Playlist?

    @IBOutlet weak var playlistTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var playlistTitle = ""
    private var viewModels =  [RecommendationCellViewModel]()
    private var tracks = [Track]()
    
    public var isOwner = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground(view: view)
        
        playlistTitleLabel.text = playlistTitle
        configureCollectionView()
        fetchPlaylistDetail()
        
        let gesture = UILongPressGestureRecognizer(target: collectionView, action: #selector(didLongPress))
        collectionView.addGestureRecognizer(gesture)
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = layout()
        collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
    }
    
    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else {
            return
        }
        let touchPoint = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint) else {
            return
        }
        
        let trackToDelete = tracks[indexPath.row]
        
        let actionSheet = UIAlertController(title: trackToDelete.name, message: NSLocalizedString("Whould you like to delete this track in playlist?", comment: ""), preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Remove", comment: ""), style: .destructive, handler: { [weak self] _ in
            guard let StrongSelf = self else {
                return
            }
            APICaller.shared.remove(track: trackToDelete, from: (StrongSelf.playlist)!) { (success) in
                DispatchQueue.main.async {
                    if success {
                        StrongSelf.tracks.remove(at: indexPath.row)
                        StrongSelf.viewModels.remove(at: indexPath.row)
                        StrongSelf.collectionView.reloadData()
                    } else {
                        print("Failed to remove")
                    }
                }
            }
        }))
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func fetchPlaylistDetail() {
        if let playlist = playlist {
            APICaller.shared.getPlaylistDetails(for: playlist) { [weak self] (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        self?.tracks = model.tracks.items.compactMap({ $0.track })
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
        
        header.delegate = self
        header.configure(with: headerModel)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // Play song
        
        let track = tracks[indexPath.row]
        
        var trackWithAlbum: [Track] = []
        trackWithAlbum.append(track)
        
        if let playerVC = storyboard?.instantiateViewController(identifier: "PlayerViewController") as? PlayerViewController {
            playerVC.tracks = trackWithAlbum
            present(playerVC, animated: true, completion: nil)
        }
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
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(375)),
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

extension PlaylistViewController: PlaylistHeaderCollectionReusableViewDelegate {
    func playlistHeaderCollectionReusableViewDelegateDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        // start playing
        if let playerVC = storyboard?.instantiateViewController(identifier: "PlayerViewController") as? PlayerViewController {
            playerVC.tracks = tracks
            present(playerVC, animated: true, completion: nil)
        }
    }
}
