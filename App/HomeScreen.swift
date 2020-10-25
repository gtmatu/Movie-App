//
//  HomeScreenViewController.swift
//  DemoApp
//
//  Created by Sofia Sarjanovic on 26/07/2017.
//  Copyright © 2017 Mateo Sarjanovic. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class HomeScreenViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, Cell1Delegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var skipMap = 0
    
    
    let apiKey = "1906833e4f7429ebcd27cb7a04da7c0a"
    let basePath = "https://api.themoviedb.org/3/discover/movie"
    var rowPathIndex:Int? = nil
    
    var fetchedFilmArray = [Film]()
    
    var parentNavigationController : UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        
        // Download film data from API
        
        let parameters: Parameters = ["api_key": self.apiKey, "sort_by" : "popularity.desc" , "language" : "en-US"]
        Alamofire.request(basePath, parameters: parameters).responseJSON { [weak self] response in
            guard let `self` = self else { return }
            
            if let json = response.result.value as? [String:Any]

            {
                
                let results = json["results"] as! NSArray
                
                for eachFilm in results {
                    
                    
                    
                    let film = eachFilm as! [String : Any]
                    let title = film["title"] as! String
                    let posterPath = film["poster_path"] as! String
                    let voteCount = film["vote_count"] as! Int
                    let overview = film["overview"] as! String
                    let rating = "\(film["vote_average"] as! Double)"
                    
                    
                    self.fetchedFilmArray.append(Film.init(title: title, posterPath: posterPath, overview: overview, voteCount: voteCount, rating: rating))
                    
                }
                
                self.collectionView.reloadData()
                
                print(self.fetchedFilmArray)
                
            }
        }
        
    }
    
    // Configure collection cells: content and quantity
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row % 3 == 0 {
            return CGSize(width: collectionView.frame.width, height: 390)
        }
        return CGSize(width: collectionView.frame.width / 2,  height: 310)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedFilmArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrototypeCell", for: indexPath) as! Cell1
        
        let film = fetchedFilmArray[indexPath.row]

        cell.cellDelegate = self
        cell.configureWithFilm(film: film)
        cell.rowPath = indexPath.row
        
        
        return cell
    }


    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    let newVC : MovieExpandedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieExpanded") as! MovieExpandedVC
        
        newVC.selectedFilm = self.fetchedFilmArray[indexPath.row]
        
        
    
    parentNavigationController!.pushViewController(newVC, animated: true)
        
    }
    

    // Map segue passing index
    
    func buttonPressed(rowPath: Int) {
        rowPathIndex = rowPath
        
        skipMap = 1
        
        mapButtonTapped(Any.self)
    }

    
    @IBAction func mapButtonTapped(_ sender: Any) {
        
        if skipMap == 1 {
        let newVC : MapViewVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapVC") as! MapViewVC
        
        newVC.indexPath = self.rowPathIndex
            
        newVC.annotationTitle = fetchedFilmArray[rowPathIndex!].title
        
        skipMap = 0
            
        parentNavigationController!.pushViewController(newVC, animated: true)
        }
    }


    
}

