//
//  Cell1.swift
//  DemoApp
//
//  Created by Sofia Sarjanovic on 26/07/2017.
//  Copyright © 2017 Mateo Sarjanovic. All rights reserved.
//

import UIKit
import Kingfisher

protocol Cell1Delegate {
    func buttonPressed(rowPath: Int)
}

class Cell1: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var cellBackground: UIView!
    var rowPath:Int? = nil
    
    var cellDelegate: Cell1Delegate? = nil


    public func configureWithFilm(film: Film){
        
        self.overviewLabel.text = film.overview
        self.titleLabel.text = film.title
        self.voteCountLabel.text = "\(film.voteCount)"
        
        self.cellBackground.layer.cornerRadius = 10
        
        let imageURL = URL(string: "https://image.tmdb.org/t/p/w500/\(film.posterPath)")
        
        let session = URLSession(configuration: .default)
        
        let downloadPicTask = session.dataTask(with: imageURL!) { (data, response, error) in
            
            if let e = error {
                print("Error downloading picture: \(e)")
            } else {
                
                if let res = response as? HTTPURLResponse {
                    print("Downloaded poster with response code \(res.statusCode)")
                        
                        if let imageURL = imageURL {
                            let resource = ImageResource(downloadURL: imageURL, cacheKey: nil)
                            self.posterView.kf.indicatorType = .activity
                            self.posterView.kf.setImage(with: resource, placeholder: nil, options: nil , progressBlock: nil, completionHandler: nil)
                        }
            
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        
        downloadPicTask.resume()

    }
    
    @IBAction func tapButton(_ sender: UIButton) {
        
        if cellDelegate != nil{
            cellDelegate?.buttonPressed(rowPath: rowPath!)
        }
        
    }
}

class Cell2:UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var ReleaseDate: UILabel!
    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var voteCountLabel: UILabel!
    
    public func configureWithFilm(film: Film){
        
        self.overviewLabel.text = film.overview
        self.titleLabel.text = film.title
        self.voteCountLabel.text = "\(film.voteCount)"
        self.ReleaseDate.text = "Average film rating : \(film.rating)"
        
        self.cellBackground.layer.cornerRadius = 10
        
        let imageURL = URL(string: "https://image.tmdb.org/t/p/w500/\(film.posterPath)")
        
        let session = URLSession(configuration: .default)
        
        let downloadPicTask = session.dataTask(with: imageURL!) { (data, response, error) in
            
            if let e = error {
                print("Error downloading picture: \(e)")
            } else {
                
                if let res = response as? HTTPURLResponse {
                    print("Downloaded poster with response code \(res.statusCode)")
                    
                    if let imageURL = imageURL {
                        let resource = ImageResource(downloadURL: imageURL, cacheKey: nil)
                        self.posterView.kf.indicatorType = .activity
                        self.posterView.kf.setImage(with: resource, placeholder: nil, options: nil , progressBlock: nil, completionHandler: nil)
                    }
                    
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        
        downloadPicTask.resume()
        
    }
    
    
    
}
