//
//  MovieExpandedVC.swift
//  DemoApp
//
//  Created by Sofia Sarjanovic on 28/07/2017.
//  Copyright © 2017 Mateo Sarjanovic. All rights reserved.
//

import UIKit
import Alamofire

class MovieExpandedVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedFilm: Film? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Automatic re-sizing for cell
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: collectionView.frame.width, height: 500)
        }
        
        collectionView.delegate = self
        
        self.collectionView.reloadData()
    
    }
    

    // var parentNavigationController : UINavigationController?
    
    // Configuring cell content
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell2
        

        cell.configureWithFilm(film: selectedFilm!)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

}
