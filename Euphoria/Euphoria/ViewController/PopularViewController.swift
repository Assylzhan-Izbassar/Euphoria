//
//  PopularViewController.swift
//  Euphoria
//
//  Created by macbook on 29.04.2021.
//

import UIKit

class PopularViewController: UIViewController, GradientBackground {
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let genres = Genre.getGenre()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        self.setGradientBackground(view: view)
        
        
        collectionView.layer.shadowColor = UIColor.black.cgColor
        collectionView.layer.shadowRadius = 10.0
        collectionView.layer.shadowOpacity = 0.15
        collectionView.layer.masksToBounds = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
}

extension PopularViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularCollectionViewCell", for: indexPath) as? PopularCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: genres[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 175, height: 101)
        
    }
    
    
    // here we can observe by clicking the cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(genres[indexPath.row].name)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 8, left: 23, bottom: 8, right: 23)
        }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}
