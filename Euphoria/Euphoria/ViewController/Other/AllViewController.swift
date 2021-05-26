//
//  AllViewController.swift
//  Euphoria
//
//  Created by macbook on 26.05.2021.
//

import UIKit

enum AllSectionType {
    case newReleases // 0
    case featuredPlaylists // 1
    case recommendedTracks // 2
}

class AllViewController: UIViewController, GradientBackground {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground(view: view)
        
        configureCollectionView()
        
//        fetchData()
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = layout()
        collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
    }
    
    private func fetchData() {
        // New Releases
        // Featured Playlists
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
                APICaller.shared.getRecommendations(genres: seeds) { _ in
                    
                }
            case .failure(_):
                break
            }
        })
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        if let firstVC = storyboard?.instantiateViewController(identifier: "TabBarViewController") {
            firstVC.modalPresentationStyle = .fullScreen
            self.present(firstVC, animated: true, completion: nil)
        }
    }
}

extension AllViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleaseCollectionViewCell.identifier, for: indexPath)
        
        if indexPath.section == 0 {
            cell.backgroundColor = .white
        } else if indexPath.section == 1 {
            cell.backgroundColor = .systemPink
        } else if indexPath.section == 2 {
            cell.backgroundColor = .systemGray
        }
        
        return cell
    }
    
    // to have diffrent section behave differently
    private func layout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment -> NSCollectionLayoutSection? in
            
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
            
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config
        
        return layout
    }
}
