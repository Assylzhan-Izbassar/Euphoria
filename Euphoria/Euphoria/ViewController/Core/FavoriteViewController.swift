//
//  FavoriteViewController.swift
//  Euphoria
//
//  Created by macbook on 29.04.2021.
//

import UIKit

enum MyMediaSectionType {
    case playlists(viewModels: [MyMediaPlaylistViewModel]) // 0
    case albums(viewModels: [MyMediaAlbumViewModel]) // 1
    
    var title: String {
        switch self {
        case .playlists:
            return NSLocalizedString("Playlists", comment: "")
        case .albums:
            return NSLocalizedString("Albums", comment: "")
        }
    }
}

class FavoriteViewController: UIViewController, GradientBackground {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cancelBtn: UIButton!
    private var sections = [MyMediaSectionType]()
    
    private var playlists: [Playlist] = [], albums: [Album] = []
    
    public var selectionHandler: ((Playlist) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setGradientBackground(view: view)
        configureCollectionView()
        
        MyMediaHeaderCollectionReusableView.delegate = self
        
        if selectionHandler != nil {
            cancelBtn.isHidden = false
        } else {
            cancelBtn.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchData()
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = layout()
    }
    
    private func fetchData() {
        
        sections.removeAll()
        playlists.removeAll()
        albums.removeAll()
        
        let group = DispatchGroup()
        group.enter()
        group.enter()
        
        // Getting user's playlists
        APICaller.shared.getCurrentUserPlaylists { [weak self] (result) in
            defer {
                group.leave()
            }
            switch result {
            case .success(let playlists):
                self?.playlists = playlists
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        
        // Getting user's albums
        APICaller.shared.getCurrentUserAlbums { [weak self] (result) in
            defer {
                group.leave()
            }
            switch result {
            case .success(let albums):
                self?.albums = albums
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        group.notify(queue: .main) { [self] in
            self.configureModels(with: playlists, albums: albums)
            collectionView.reloadData()
        }
    }
    
    private func configureModels(with playlists: [Playlist], albums: [Album]) {
        
        // Configure models
        sections.append(.playlists(viewModels: playlists.compactMap({
            return MyMediaPlaylistViewModel(
                name: $0.name
            )
        })))
        
        sections.append(.albums(viewModels: albums.compactMap({
            return MyMediaAlbumViewModel(name: $0.name, imageUrl: URL(string: $0.images.first?.url ?? ""), creatorName: $0.artists.first?.name)
        })))
    }
    
    
    @IBAction func dismissVC(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension FavoriteViewController: MyMediaHeaderCollectionReusableViewDelegate {
    func addNewPlaylist() {
        let alert = UIAlertController(title:  NSLocalizedString("New Playlists", comment: ""), message: NSLocalizedString("Enter playlist title", comment: ""), preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("Playlist...", comment: "")
            
        }
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Create", comment: ""), style: .default, handler: { (_) in
            guard
                let field = alert.textFields?.first,
                let text = field.text,
                !text.trimmingCharacters(in: .whitespaces).isEmpty
            else {
                return
            }
            
            APICaller.shared.createPlaylist(with: text) { [weak self] (success) in
                if success {
                    self?.fetchData()
                } else {
                    print("Error accures when creating a playlist!")
                }
            }
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func addNewAlbum() {
        if let AlbumsVC = storyboard?.instantiateViewController(identifier: "BrowersAlbumViewController") as? BrowersAlbumViewController {
            AlbumsVC.modalPresentationStyle = .fullScreen
            self.present(AlbumsVC, animated: true, completion: nil)
        }
    }
}

extension FavoriteViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .playlists(let viewModels):
            return viewModels.count
        case .albums(let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let type = sections[safe: indexPath.section] {
            switch type {
            case .playlists(let viewModels):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCollectionViewCell", for: indexPath) as? FavoriteCollectionViewCell
                else {
                    return UICollectionViewCell()
                }
                cell.makeRoundedCorners(30.0, 10.0, CGSize(width: 5, height: 10))
                cell.configure(with: viewModels[indexPath.row])
                return cell
            case .albums(let viewModels):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyMediaAlbumCollectionViewCell.identifier, for: indexPath) as? MyMediaAlbumCollectionViewCell
                else {
                    return UICollectionViewCell()
                }
                cell.configure(with: viewModels[indexPath.row])
                return cell
            }
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: MyMediaHeaderCollectionReusableView.identifier,
                for: indexPath) as? MyMediaHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader
        else {
            return UICollectionReusableView()
        }
        
        let section = indexPath.section
        header.configure(with: sections[section].title)
        
        return header
    }
    
    // here we can observe by clicking the cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let section = sections[indexPath.section]
        
        switch section {
        case .playlists:
            guard selectionHandler == nil else {
                selectionHandler?(playlists[indexPath.row])
                dismiss(animated: true, completion: nil)
                return
            }
            if let playlistVC = storyboard?.instantiateViewController(identifier: "PlaylistViewController") as? PlaylistViewController {
                playlistVC.playlist = playlists[indexPath.row]
                playlistVC.isOwner = true
                playlistVC.modalPresentationStyle = .fullScreen
                self.present(playlistVC, animated: true, completion: nil)
            }
        case .albums:
            if let albumVC = storyboard?.instantiateViewController(identifier: "AlbumViewController") as? AlbumViewController {
                albumVC.album = albums[indexPath.row]
                albumVC.modalPresentationStyle = .fullScreen
                self.present(albumVC, animated: true, completion: nil)
            }
        }
    }
    
    // to have diffrent section behave differently
    private func layout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment -> NSCollectionLayoutSection? in
            
            let supplementaryViews = [
                NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50)),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
            ]
            
            if sectionIndex == 0 {
                // Item
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                
                // Group
                // Vertical group inside the horizontal group
                let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize:
                                                                        NSCollectionLayoutSize(widthDimension: .absolute(360), heightDimension: .absolute(360)),
                                                                     subitem: item,
                                                                     count: 2)
                let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize:
                                                                            NSCollectionLayoutSize(widthDimension: .absolute(360), heightDimension: .absolute(360)),
                                                                         subitem: verticalGroup,
                                                                         count: 2)
                
                // Section
                let section = NSCollectionLayoutSection(group: horizontalGroup)
                section.boundarySupplementaryItems = supplementaryViews
                section.orthogonalScrollingBehavior = .groupPaging
                
                return section
                
            } else if sectionIndex == 1 {
                
                // Item
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                
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
                section.boundarySupplementaryItems = supplementaryViews
                
                return section
                
            }
            
            // Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            // Group
            let group = NSCollectionLayoutGroup.vertical(layoutSize:
                                                            NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(360)),
                                                         subitem: item,
                                                         count: 1)
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 5
        layout.configuration = config
        
        return layout
    }
}
