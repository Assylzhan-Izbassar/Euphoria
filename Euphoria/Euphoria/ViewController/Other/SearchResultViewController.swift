//
//  SearchResultViewController.swift
//  Euphoria
//
//  Created by macbook on 28.05.2021.
//

import UIKit

class SearchResultViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let searchFieldImage = UIImage(named: "search_img") {
            searchTextField.setLeftIcon(searchFieldImage)
            makeRoundedTextField()
        }
        
        searchTextField.delegate = self
    }
    
    private func makeRoundedTextField() {
        
        //Basic texfield Setup
        searchTextField.borderStyle = .none
        searchTextField.backgroundColor = .white

        //To apply corner radius
        searchTextField.layer.cornerRadius = searchTextField.frame.size.height / 2

        //To apply border
        searchTextField.layer.borderWidth = 0.25
        searchTextField.layer.borderColor = UIColor.white.cgColor

        //To apply Shadow
        searchTextField.layer.shadowOpacity = 1
        searchTextField.layer.shadowRadius = 0.0
        searchTextField.layer.shadowPath = UIBezierPath(roundedRect: searchTextField.bounds, cornerRadius: searchTextField.layer.cornerRadius).cgPath
        searchTextField.layer.shadowOffset = CGSize(width: 10.0, height: 15.0)
        searchTextField.layer.shadowColor = UIColor(red: 255/255.0, green: 181/255.0, blue: 211/255.0, alpha: 1.0).cgColor
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = layout()
        collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
    }
    
    private func searchedResults() {
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as! SearchResultCollectionViewCell
        
//        cell.configure(with: viewModels[indexPath.row])
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        guard let header = collectionView.dequeueReusableSupplementaryView(
//                ofKind: kind,
//                withReuseIdentifier: AlbumHeaderCollectionReusableView.identifier,
//                for: indexPath) as? AlbumHeaderCollectionReusableView,
//              kind == UICollectionView.elementKindSectionHeader
//        else {
//            return UICollectionReusableView()
//        }
//        let headerModel = AlbumHeaderViewModel(title: album?.name,
//                                               artistName: album?.artists.first?.name,
//                                               releasedDate: album?.release_date,
//                                               imageUrl: URL(string: album?.images.first?.url ?? ""))
//        header.configure(with: headerModel)
//
//        return header
//    }
    
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
                                                            NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80)),
                                                         subitem: item,
                                                         count: 1)
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            // Needed for collection header
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50)),
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

extension SearchResultViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if searchTextField.text?.count ?? 0 > 0 {
            self.dismiss(animated: true, completion: nil)
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
