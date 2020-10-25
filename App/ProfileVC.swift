//
//  ProfileVC.swift
//  DemoApp
//
//  Created by Sofia Sarjanovic on 01/08/2017.
//  Copyright © 2017 Mateo Sarjanovic. All rights reserved.
//

import UIKit
import Kingfisher
import FBSDKCoreKit
import FBSDKShareKit
import PageMenu

class ProfileVC: UIViewController, CAPSPageMenuDelegate {

    @IBOutlet weak var profilePictureView: UIImageView!
    
    var pageMenu : CAPSPageMenu?
    
    @IBOutlet weak var pageMenuView: UIView!
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        // Profile picture view settings

        profilePictureView.layer.borderWidth=1.0
        profilePictureView.layer.masksToBounds = false
        profilePictureView.layer.borderColor = UIColor.white.cgColor
        profilePictureView.layer.cornerRadius = profilePictureView.frame.size.height/2
        profilePictureView.clipsToBounds = true
        
        
        // Handling profile picture - if no user logged in display icon

        if LoggedInUser.loggedUser.userID != nil {
        
        let profilePicture : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/\(LoggedInUser.loggedUser.userID!)/picture", parameters: ["height":250, "widht":250, "redirect":false], httpMethod: "GET")
        profilePicture.start(completionHandler: { (connection, result, error) -> Void in
            
                if error == nil {
                    
                    let dictionary = result as? NSDictionary
                    let data = dictionary?.object(forKey: "data")
                    
                    let picURL = ((data as AnyObject).value(forKey: "url")) as! String
                    let imageURL = URL(string: picURL)
                    
                    let resource = ImageResource(downloadURL: imageURL!, cacheKey: nil)
                    self.profilePictureView.kf.indicatorType = .activity
                    self.profilePictureView.kf.setImage(with: resource, placeholder: nil, options: nil , progressBlock: nil, completionHandler: nil)
                }
            })
        } else {
            profilePictureView.image = UIImage(named: "PersonIcon")
            profilePictureView.tintColor = UIColor.white
        }
 
        
        // Page Menu initialization
        
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
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width: self.pageMenuView.frame.width, height: self.pageMenuView.frame.height), pageMenuOptions: parameters)
        
        pageMenu!.delegate = self
        self.pageMenuView.addSubview(pageMenu!.view)
    }
    
    
    // If no user is logged in present option to go to log in page
    
    @IBAction func settingsPressed(_ sender: Any) {

        if LoggedInUser.loggedUser.phoneNumber == nil {
            
            let alert = UIAlertController(title: "Alert", message: "You must be logged in in order to make changes to a user. Log in now?", preferredStyle: UIAlertControllerStyle.alert)
            let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
            let logInButton = UIAlertAction(title: "Log In", style: UIAlertActionStyle.default, handler: { (nil) in
                self.performSegue(withIdentifier: "logIn", sender: self)
            })
            
            alert.addAction(cancelButton)
            alert.addAction(logInButton)
            
            present(alert, animated: true, completion: nil)
            
        } else {
            performSegue(withIdentifier: "goToSettings", sender: self)
        }
    }
    
}
