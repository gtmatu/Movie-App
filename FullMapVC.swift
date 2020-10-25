//
//  FullMapVC.swift
//  DemoApp
//
//  Created by Sofia Sarjanovic on 31/07/2017.
//  Copyright © 2017 Mateo Sarjanovic. All rights reserved.
//

import UIKit
import Alamofire
import MapKit

class FullMapVC: UIViewController {
    
    let apiKey = "1906833e4f7429ebcd27cb7a04da7c0a"
    let basePath = "https://api.themoviedb.org/3/discover/movie"
    
    @IBOutlet weak var fullMapView: MKMapView!
    
    var fetchedArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetching film data from API
        
        let parameters: Parameters = ["api_key": self.apiKey, "sort_by" : "popularity.desc" , "language" : "en-US"]
        Alamofire.request(basePath, parameters: parameters).responseJSON { [weak self] response in
            guard let `self` = self else { return }
            
            if let json = response.result.value as? [String:Any]
                
            {
                
                let results = json["results"] as! NSArray
                
                for (index, eachFilm) in results.enumerated() {
                    
                    let film = eachFilm as! [String : Any]
                    let fetchedTitle = film["title"] as! String
                    let tempOffset:Double = Double(index)
                    let offset:Double = tempOffset/80
                    var latitude:Double? = nil
                    var longitude:Double? = nil

                    // Setting random locations for movies
                    
                    if index % 2 == 0{
                        latitude = 51.5 + offset
                    } else {
                        latitude = 51.5 - offset
                    }
                    
                    if index % 3 == 1 {
                        longitude = offset - 0.15
                    } else {
                        longitude = -0.15 - offset
                    }
                    
                    // Creating map annotation for each movie
                    
                    let annotation = MKPointAnnotation()
                    annotation.title = fetchedTitle
                    annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                    self.fullMapView.addAnnotation(annotation)
                    
                }
            }
        }

        // Initializing map to show all annotations
        
        let span = MKCoordinateSpan(latitudeDelta: 0.6, longitudeDelta: 0.6)
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(51.5, -0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.fullMapView.setRegion(region, animated:true)
        
    }
    
}
