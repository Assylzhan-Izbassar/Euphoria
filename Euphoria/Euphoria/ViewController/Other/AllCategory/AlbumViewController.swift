//
//  AlbumViewController.swift
//  Euphoria
//
//  Created by macbook on 27.05.2021.
//

import UIKit

class AlbumViewController: UIViewController, GradientBackground {

    var album: Album?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    
    var albumName = ""
    private var viewModels =  [AlbumDetailsCellViewModel]()
    private var tracks = [Track]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground(view: view)
        
        albumTitleLabel.text = albumName
        configureCollectionView()
        fetchAlbumDetail()
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = layout()
        collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
    }
    
    private func fetchAlbumDetail() {
        if let album = album {
            APICaller.shared.getAlbumDetails(for: album) { [weak self](result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        self?.tracks = model.tracks.items
                        self?.viewModels = model.tracks.items.compactMap({
                            return AlbumDetailsCellViewModel(
                                name: $0.name,
                                artistName: $0.artists.first?.name ?? "No name")
                                
                        })
                        self?.collectionView.reloadData()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    @IBAction func addToMyMedia(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: album?.name, message: NSLocalizedString("Actions", comment: ""), preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Save", comment: ""), style: .default, handler: { [weak self] _ in
            guard let strongSelf = self else { return }
            APICaller.shared.saveAlbumToCurrentUser(album: strongSelf.album!) {
                success in
                print(success)
            }
        }))
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumDetailsCollectionViewCell.identifier, for: indexPath) as! AlbumDetailsCollectionViewCell
        
        cell.configure(with: viewModels[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: AlbumHeaderCollectionReusableView.identifier,
                for: indexPath) as? AlbumHeaderCollectionReusableView,
              kind == UICollectionView.elementKindSectionHeader
        else {
            return UICollectionReusableView()
        }
        let headerModel = AlbumHeaderViewModel(title: album?.name,
                                               artistName: album?.artists.first?.name,
                                               releasedDate: album?.release_date,
                                               imageUrl: URL(string: album?.images.first?.url ?? ""))
        header.delegate = self
        header.configure(with: headerModel)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // Play song
        var track = tracks[indexPath.row]
        track.album = self.album
        
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
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(320)),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
            ]
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config
        
        return layout
    }
}

extension AlbumViewController: AlbumHeaderCollectionReusableViewDelegate {
    func albumHeaderCollectionReusableViewDelegateDidTapPlayAll(_ header: AlbumHeaderCollectionReusableView) {
        let trackWithAlbum: [Track] = tracks.compactMap ({
            var track = $0
            track.album = self.album
            return track
        })
        
        if let playerVC = storyboard?.instantiateViewController(identifier: "PlayerViewController") as? PlayerViewController {
            playerVC.tracks = trackWithAlbum
            present(playerVC, animated: true, completion: nil)
        }
    }
}
