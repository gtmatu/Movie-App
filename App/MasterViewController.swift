//
//  MasterViewController.swift
//  DemoApp
//
//  Created by Sofia Sarjanovic on 26/07/2017.
//  Copyright © 2017 Mateo Sarjanovic. All rights reserved.
//

import UIKit
import PageMenu
import FBSDKShareKit
import FBSDKCoreKit
import Kingfisher

class MasterViewController: UIViewController, CAPSPageMenuDelegate, UISearchBarDelegate {

    var pageMenu : CAPSPageMenu?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Set up last tab icon
        
        if LoggedInUser.loggedUser.userID != nil {
            
            let profilePicture : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/\(LoggedInUser.loggedUser.userID!)/picture", parameters: ["height":150, "widht":150, "redirect":false], httpMethod: "GET")
            profilePicture.start(completionHandler: { (connection, result, error) -> Void in
                
                if error == nil {
                    
                    let dictionary = result as? NSDictionary
                    let data = dictionary?.object(forKey: "data")
                    
                    let picURL = ((data as AnyObject).value(forKey: "url")) as! String
                    let imageURL = URL(string: picURL)
                    
                    KingfisherManager.shared.retrieveImage(with: imageURL!, options: nil, progressBlock: nil) { (image, error, cacheType, imageURL) -> () in
 
                        let newImage = self.reSizeImageAndMakeCircular(image: image!)
                        
                        self.tabBarController?.tabBar.items![3].image = newImage.withRenderingMode(.alwaysOriginal)
                        self.tabBarController?.tabBar.items![3].selectedImage = newImage.withRenderingMode(.alwaysOriginal)
                    
                    }
                    
                }
            })
            
        } else {
            
            self.tabBarController?.tabBar.items![3].image = reSizeImageAndMakeCircular(image: UIImage(named: "PersonIcon")!)
            self.tabBarController?.tabBar.items![3].selectedImage = reSizeImageAndMakeCircular(image: UIImage(named: "PersonIcon")!)
        }
  
        
        // Set up Page Menu
        
        let controller : HomeScreenViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DiscoverScene") as! HomeScreenViewController
        controller.title = "DISCOVER"
        controller.parentNavigationController = self.navigationController
        
        let controller1 : HomeScreenViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DiscoverScene") as! HomeScreenViewController
        controller1.title = "FAVOURITES"
        controller1.parentNavigationController = self.navigationController
        
        let controllerArray : [UIViewController] = [controller, controller1]
        
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(4.3),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorPercentageHeight(0.1),
            .selectionIndicatorColor(customRed),
            .selectionIndicatorHeight(3.0),
            .selectedMenuItemLabelColor(customRed),
            .scrollMenuBackgroundColor(.white),
            .menuHeight(55.0),
            .enableHorizontalBounce(true),
            .menuItemSeparatorRoundEdges(true),
            .menuItemSeparatorColor(.white),
            .menuItemFont(UIFont(name:"ProximaNova-Light", size: 16.0)!)
        ]

        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        
        pageMenu!.delegate = self
        self.view.addSubview(pageMenu!.view)
    }
    
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        present(searchController, animated: true, completion: nil)
        
    }
    
    
    func reSizeImageAndMakeCircular(image: UIImage) -> UIImage{
        
        let cornerRadius = image.size.height/2
        let size = CGSize(width: 30.0, height: 30.0)
        let bounds = CGRect(origin: CGPoint(x: 0,y :0), size: size)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).addClip()
        image.draw(in: bounds)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        return finalImage!
    }
    
    
}
