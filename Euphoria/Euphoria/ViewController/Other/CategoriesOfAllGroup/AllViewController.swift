//
//  AllViewController.swift
//  Euphoria
//
//  Created by macbook on 26.05.2021.
//

import UIKit

enum AllSectionType {
    case newReleases(viewModels: [NewReleasesCellViewModel]) // 0
    case featuredPlaylists(viewModels: [FeaturedPlaylistCellViewModel]) // 1
    case recommendedTracks(viewModels: [RecommendationCellViewModel]) // 2
    
    var title: String {
        switch self {
        case .newReleases:
            return "New Released Albums"
        case .featuredPlaylists:
            return "Featured Playlists"
        case .recommendedTracks:
            return "Recommended"
        }
    }
}
    
class AllViewController: UIViewController, GradientBackground {

    @IBOutlet weak var collectionView: UICollectionView!
    private var sections = [AllSectionType]()
    
    private var newAlbums: [Album] = [], playlists: [Playlist] = [], tracks: [Track] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground(view: view)
        
        configureCollectionView()
        
        fetchData()
        
        addLongTapGesture()
    }
    
    private func addLongTapGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        collectionView.addGestureRecognizer(gesture)
    }
    
    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else {
            return
        }
        let touchPoint = gesture.location(in: collectionView)
        
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint),
              indexPath.section == 2 else {
            return
        }
        
        let model = tracks[indexPath.row]
        
        let actionSheet = UIAlertController(title: model.name, message: "Would you like to add track to playlist?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
            DispatchQueue.main.async {
                if let myMediaVC = self?.storyboard?.instantiateViewController(identifier: "FavoriteViewController") as? FavoriteViewController {
                    myMediaVC.modalPresentationStyle = .fullScreen
                    
                    myMediaVC.selectionHandler = { playlist in
                        APICaller.shared.add(track: model, to: playlist) { (success) in
                            // Alert
                            print("Added!")
                        }
                    }
                    
                    self?.present(myMediaVC, animated: true, completion: nil)
                }
            }
        }))
        
        present(actionSheet, animated: true)
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = layout()
        collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
    }
    
    private func fetchData() {
        
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        var newReleases: NewReleasesResponse?
        var featuredPlaylist: FeaturedPlaylistResponse?
        var recommendationResponse: RecomendationResponse?
        
        // New Releases
        APICaller.shared.getNewReleases { (result) in
            defer {
                group.leave()
            }
            switch result {
            case.success(let model):
                newReleases = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        // Featured Playlists
        APICaller.shared.getFeaturedPlaylists { (result) in
            defer {
                group.leave()
            }
            switch result {
            case.success(let model):
                featuredPlaylist = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        // Recommended Tracks
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
                APICaller.shared.getRecommendations(genres: seeds) { recommendedResult in
                    defer {
                        group.leave()
                    }
                    switch recommendedResult {
                    case .success(let model):
                        recommendationResponse = model
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
        
        group.notify(queue: .main) { [self] in
            guard
                let newAlbums  = newReleases?.albums.items,
                let playlists = featuredPlaylist?.playlists.items,
                let tracks = recommendationResponse?.tracks
            else {
                return
            }
            
            self.configureModels(with: newAlbums, playlists: playlists, tracks: tracks)
            
            collectionView.reloadData()
        }
    }
    
    private func configureModels(with newAlbums: [Album], playlists: [Playlist], tracks: [Track]) {
        
        self.newAlbums = newAlbums
        self.playlists = playlists
        self.tracks = tracks
        
        // Configure models
        sections.append(.newReleases(viewModels: newAlbums.compactMap({
            return NewReleasesCellViewModel(name: $0.name,
                                            artWorkUrl: URL(string: $0.images.first?.url ?? ""),
                                            numberOfTracks: $0.total_tracks,
                                            artistName: $0.artists.first?.name ?? "No name")
        })))
        sections.append(.featuredPlaylists(viewModels: playlists.compactMap({
            return FeaturedPlaylistCellViewModel(
                name: $0.name,
                imageUrl: URL(string: $0.images.first?.url ?? ""),
                creatorName: $0.owner.display_name)
        })))
        sections.append(.recommendedTracks(viewModels: tracks.compactMap({
            return RecommendationCellViewModel(
                name: $0.name,
                artistName: $0.artists.first?.name,
                artworkURL: URL(string: $0.album?.images.first?.url ?? ""))
        })))
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AllViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .newReleases(let viewModels):
            return viewModels.count
        case .featuredPlaylists(let viewModels):
            return viewModels.count
        case .recommendedTracks(let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = sections[indexPath.section]
        switch type {
        case .newReleases(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewReleaseCollectionViewCell.identifier,
                    for: indexPath) as? NewReleaseCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        case .featuredPlaylists(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier,
                    for: indexPath) as? FeaturedPlaylistCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        case .recommendedTracks(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier,
                    for: indexPath) as? RecommendedTrackCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TitleHeaderCollectionReusableView.identifier,
                for: indexPath) as? TitleHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader
        else {
            return UICollectionReusableView()
        }
        
        let section = indexPath.section
        
        header.configure(with: sections[section].title)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let section = sections[indexPath.section]
        
        switch section {
        case .newReleases:
            let album = newAlbums[indexPath.row]
            if let AlbumVC = storyboard?.instantiateViewController(identifier: "AlbumViewController") as? AlbumViewController {
                AlbumVC.modalPresentationStyle = .fullScreen
                AlbumVC.album = album
                AlbumVC.albumName = album.name
                self.present(AlbumVC, animated: true, completion: nil)
            }
        case .featuredPlaylists:
            let playlist = playlists[indexPath.row]
            if let PlaylistVC = storyboard?.instantiateViewController(identifier: "PlaylistViewController") as? PlaylistViewController {
                PlaylistVC.modalPresentationStyle = .fullScreen
                PlaylistVC.playlist = playlist
                PlaylistVC.playlistTitle = playlist.name
                self.present(PlaylistVC, animated: true, completion: nil)
            }
        case .recommendedTracks:
            let track = tracks[indexPath.row]
            PlayerPresenter.shared.startPlayer(from: self, track: track)
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
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                
                // Group
                // Vertical group inside the horizontal group
                let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize:
                                                                        NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(360)),
                                                                     subitem: item,
                                                                     count: 3)
                let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize:
                                                                            NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(360)),
                                                                         subitem: verticalGroup,
                                                                         count: 1)
                
                // Section
                let section = NSCollectionLayoutSection(group: horizontalGroup)
                section.boundarySupplementaryItems = supplementaryViews
                section.orthogonalScrollingBehavior = .groupPaging
                
                return section
                
            } else if sectionIndex == 1 {
                
                // Item
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                
                // Group
                // Vertical group inside the horizontal group
                let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize:
                                                                        NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(400)),
                                                                     subitem: item,
                                                                     count: 2)
                let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize:
                                                                            NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(400)),
                                                                         subitem: verticalGroup,
                                                                         count: 1)
                
                // Section
                let section = NSCollectionLayoutSection(group: horizontalGroup)
                section.boundarySupplementaryItems = supplementaryViews
                section.orthogonalScrollingBehavior = .continuous
                
                return section
                
            } else if sectionIndex == 2 {
                
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
                section.boundarySupplementaryItems = supplementaryViews
                
                return section
            }
            
            // Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
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
