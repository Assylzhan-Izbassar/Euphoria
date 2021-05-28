//
//  PopularViewController.swift
//  Euphoria
//
//  Created by macbook on 29.04.2021.
//

import UIKit

class PopularViewController: UIViewController, GradientBackground {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var categories = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setGradientBackground(view: view)
        
        collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        fetchData()
    }
    
    private func fetchData() {
        APICaller.shared.getCategories { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let models):
                    self?.categories = models.categories.items
                    self?.collectionView.reloadData()
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
}

extension PopularViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(categories.count)
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularCollectionViewCell", for: indexPath) as? PopularCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        cell.makeRoundedCorners(30.0, 5.0, CGSize(width: 5.0, height: 10.0))
        cell.configure(with: categories[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 175, height: 101)
    }

    // here we can observe by clicking the cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(categories[indexPath.row].name)
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
