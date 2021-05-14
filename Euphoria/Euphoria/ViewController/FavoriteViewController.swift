//
//  FavoriteViewController.swift
//  Euphoria
//
//  Created by macbook on 29.04.2021.
//

import UIKit

class FavoriteViewController: UIViewController, GradientBackground {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let albums = Album.getAlbums()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setGradientBackground(view: view)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
}

extension FavoriteViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCollectionViewCell", for: indexPath) as? FavoriteCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        cell.setup(with: albums[indexPath.row])
        
        return cell
    }
    
    // here we should change next
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 160)
    }
    
    // here we can observe by clicking the cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(albums[indexPath.row].name)
    }
}
