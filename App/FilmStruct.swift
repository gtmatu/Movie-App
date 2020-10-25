//
//  File.swift
//  DemoApp
//
//  Created by Sofia Sarjanovic on 26/07/2017.
//  Copyright © 2017 Mateo Sarjanovic. All rights reserved.
//

import Foundation
import Alamofire

struct Film {
    
    let title:String
    let posterPath:String
    let overview:String
    let voteCount:Int
    let rating:String
    
    
    init(title : String , posterPath : String , overview : String , voteCount : Int, rating : String) {
        
        self.title = title
        self.posterPath = posterPath
        self.overview = overview
        self.voteCount = voteCount
        self.rating = rating
        
    }
    
    
    
}
