//
//  FavoriteViewController.swift
//  Euphoria
//
//  Created by macbook on 29.04.2021.
//

import UIKit

enum MyMediaSectionType {
    case playlists(viewModels: [FeaturedPlaylistCellViewModel]) // 0
    case albums(viewModels: [NewReleasesCellViewModel]) // 1
    
    var title: String {
        switch self {
        case .playlists:
            return "Playlists"
        case .albums:
            return "Albums"
        }
    }
}

class FavoriteViewController: UIViewController, GradientBackground {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cancelBtn: UIButton!
    private var sections = [MyMediaSectionType]()
    
//    let albums = Album.getAlbums()
    var playlists = [Playlist]()
    var albums = [Album]()
    
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
        
        let group = DispatchGroup()
        group.enter()
        
        APICaller.shared.getCurrentUserPlaylists { [weak self] (result) in
            defer {
                group.leave()
            }
            switch result {
            case .success(let models):
                self?.playlists = models
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        
        group.notify(queue: .main) { [self] in
            self.configureModels(with: playlists, albums: albums)
            collectionView.reloadData()
        }
    }
    
    private func configureModels(with playlists: [Playlist], albums: [Album]) {
        
        self.playlists = playlists
//        self.albums = albums
        
        // Configure models
        sections.append(.playlists(viewModels: playlists.compactMap({
            return FeaturedPlaylistCellViewModel(
                name: $0.name,
                imageUrl: URL(string: $0.images.first?.url ?? ""),
                creatorName: $0.owner.display_name)
        })))
        
//        sections.append(.albums(viewModels: albums.compactMap({
//            return NewReleasesCellViewModel(name: $0.name,
//                                            artWorkUrl: URL(string: $0.images.first?.url ?? ""),
//                                            numberOfTracks: $0.total_tracks,
//                                            artistName: $0.artists.first?.name ?? "No name")
//        })))
    }
    
    
    @IBAction func dismissVC(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension FavoriteViewController: MyMediaHeaderCollectionReusableViewDelegate {
    func addNewPlaylist() {
        let alert = UIAlertController(title:  "New Playlists", message: "Enter playlist title", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Playlist..."
        }
        
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { (_) in
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
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}

extension FavoriteViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCollectionViewCell", for: indexPath) as? FavoriteCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        cell.makeRoundedCorners(30.0, 10.0, CGSize(width: 5, height: 10))
        cell.setup(with: playlists[indexPath.row])
        
        return cell
    }
    
    // here we can observe by clicking the cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard selectionHandler == nil else {
            selectionHandler?(playlists[indexPath.row])
            dismiss(animated: true, completion: nil)
            return
        }
        
        if let playlistVC = storyboard?.instantiateViewController(identifier: "PlaylistViewController") as? PlaylistViewController {
            playlistVC.playlist = playlists[indexPath.row]
            playlistVC.modalPresentationStyle = .fullScreen
            self.present(playlistVC, animated: true, completion: nil)
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
        
//        let section = indexPath.section
        
//        header.configure(with: sections[section].title, section: section)
        
        return header
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
                                                                        NSCollectionLayoutSize(widthDimension: .absolute(320), heightDimension: .absolute(320)),
                                                                     subitem: item,
                                                                     count: 1)
                let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize:
                                                                            NSCollectionLayoutSize(widthDimension: .absolute(320), heightDimension: .absolute(320)),
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
        config.interSectionSpacing = 10
        layout.configuration = config
        
        return layout
    }
}
