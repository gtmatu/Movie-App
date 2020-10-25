//
//  MapViewVC.swift
//  DemoApp
//
//  Created by Sofia Sarjanovic on 31/07/2017.
//  Copyright © 2017 Mateo Sarjanovic. All rights reserved.
//

import UIKit
import MapKit

class MapViewVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var indexPath: Int? = nil
    var annotationTitle:String? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tempOffset:Double = Double(indexPath!)
        let offset:Double = tempOffset/80
        var latitude:Double? = nil
        var longitude:Double? = nil
        
        // Setting random location for movie
        
        if indexPath! % 2 == 0{
            latitude = 51.5 + offset
        } else {
            latitude = 51.5 - offset
        }
        
        if indexPath! % 3 == 1 {
            longitude = offset - 0.15
        } else {
            longitude = -0.15 - offset
        }
        
        // Creating map annotation
        
        let annotation = MKPointAnnotation()
        annotation.title = annotationTitle
        annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
        self.mapView.addAnnotation(annotation)
        
        // Setting map to initialize on correct location
        
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
        let span = MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
        
    }
    
}
