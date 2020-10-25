//
//  SignInSignUpViewController.swift
//  DemoApp
//
//  Created by Sofia Sarjanovic on 20/07/2017.
//  Copyright © 2017 Mateo Sarjanovic. All rights reserved.
//

import UIKit
import CoreData


class SignInSignUpViewController: UIViewController, UITextFieldDelegate {
    
    var userPhoneNumberArray:[String] = []
    var userArray:[User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up tap detection
        
        self.phoneNumberTextField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        self.view.addGestureRecognizer(tap)
    
        
        // Extracting Users from Core data
                
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        request.returnsObjectsAsFaults = false
 
        do {
            
            userArray = try context.fetch(User.fetchRequest())
            
            if userArray.count > 0 {
                for result in userArray {
                    userPhoneNumberArray.append(result.phoneNumber!)
                }
            }
            
        } catch { displayAlertMessage(alertMessage: "Unable to retrieve user data") }
        
    }
    
    
    func handleTap(){
        self.phoneNumberTextField.resignFirstResponder()
    }
    
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
   
    // Check length of phone number is correct (10 characters) and if present in Core Data
    
    @IBAction func phoneNumberInput(_ sender: UIButton) {
        
        let userPhoneNumber = phoneNumberTextField.text
        
        if userPhoneNumber?.characters.count != 10 {
            
            displayAlertMessage(alertMessage: "Phone number must be 10 numbers long")
            
        } else if userPhoneNumberArray.contains(userPhoneNumber!){
            
            // Assign profile to logged user
            
            let index = userPhoneNumberArray.index(of: userPhoneNumber!)
            
            if userArray[index!].gender == "1" {
                LoggedInUser.loggedUser.gender = 1
            } else { LoggedInUser.loggedUser.gender = 0 }
            
            if userArray[index!].age != nil {
                LoggedInUser.loggedUser.age = userArray[index!].age
            } else { LoggedInUser.loggedUser.age = "0" }
            
            if userArray[index!].userID != nil {
                LoggedInUser.loggedUser.userID = userArray[index!].userID
            }
            
            
            LoggedInUser.loggedUser.customInit(phoneNumber: userArray[index!].phoneNumber!, password: userArray[index!].password!, firstName: userArray[index!].firstName!, lastName: userArray[index!].lastName!, email: userArray[index!].email!)

            performSegue(withIdentifier: "SignIn Flow", sender: self)
            
        } else{ // Assign phone number to logged user and proceed to sign up flow
            
            LoggedInUser.loggedUser.phoneNumber = userPhoneNumber
            
            performSegue(withIdentifier: "SignUp Flow", sender: self)
        }
    }
    
}
