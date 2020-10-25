//
//  FillInInfoViewController.swift
//  DemoApp
//
//  Created by Sofia Sarjanovic on 21/07/2017.
//  Copyright © 2017 Mateo Sarjanovic. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import CoreData

class FillInInfoViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up tap recognition to exit text fields
        
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.emailTextField.delegate = self
    
        let tap = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        
        self.view.addGestureRecognizer(tap)
        
    }
    
    
    func handleTap(){
        self.firstNameTextField.resignFirstResponder()
        self.lastNameTextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
    }
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        let userFirstName = firstNameTextField.text
        let userLastName = lastNameTextField.text
        let userEmail = emailTextField.text
        
        // Checking all fields filled in and email is valid
        
        if userFirstName?.characters.count == 0 || userLastName?.characters.count == 0 || userEmail?.characters.count == 0 {
            
            displayAlertMessage(alertMessage: "All fields required")
            
        } else if validateEmail(candidate: userEmail!) {
            
            // Assign to logged user, save to Core Data and segue to next Discover page
            
            LoggedInUser.loggedUser.firstName = userFirstName
            LoggedInUser.loggedUser.lastName = userLastName
            LoggedInUser.loggedUser.email = userEmail
            
            let newUser = User(context: context)
            
            newUser.phoneNumber = LoggedInUser.loggedUser.phoneNumber
            newUser.password = LoggedInUser.loggedUser.password
            newUser.firstName = LoggedInUser.loggedUser.firstName
            newUser.lastName = LoggedInUser.loggedUser.lastName
            newUser.email = LoggedInUser.loggedUser.email
            newUser.userID = LoggedInUser.loggedUser.userID
            
            if LoggedInUser.loggedUser.gender == 1 {
                newUser.gender = "1"
            } else { newUser.gender = "0" }
            
            appDelegate.saveContext()
            
            performSegue(withIdentifier: "SignUp Complete", sender: self)

        } else {
            displayAlertMessage(alertMessage: "Please enter valid email address")
        }
    }
    
    
    @IBAction func FBButtonPressed(_ sender: Any) {
        
        // Log into facebook
        let FBLogInManager = FBSDKLoginManager.init()
        FBLogInManager.loginBehavior = FBSDKLoginBehavior.web
        
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self)
        { (result, err) in
            
            if err != nil {
                self.displayAlertMessage(alertMessage: "Unable to import data from Facebook")
                print(err!)
                return
            }
            
            // Retrieving email, name, id from Facebook
            
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "email , first_name , last_name"]).start{
                (connection, result, err) in
                
                if err != nil {
                    self.displayAlertMessage(alertMessage: "Unable to import data from Facebook")
                }
                
                // Assigning Facebook values to textfields
                
                self.emailTextField.text = (result as AnyObject).value(forKey: "email")! as? String
                self.firstNameTextField.text = (result as AnyObject).value(forKey: "first_name")! as? String
                self.lastNameTextField.text = (result as AnyObject).value(forKey: "last_name")! as? String
                LoggedInUser.loggedUser.userID = (result as AnyObject).value(forKey: "id")! as? String
                
                
                FBLogInManager.logOut()
            }
        }
    }
    

}
