//
//  SettingsVC.swift
//  DemoApp
//
//  Created by Sofia Sarjanovic on 02/08/2017.
//  Copyright © 2017 Mateo Sarjanovic. All rights reserved.
//

import UIKit
import CoreData

class SettingsVC: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var mfSelector: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.layer.cornerRadius = 10
        
        // Initializing text fields with saved values

        firstNameTF.text = LoggedInUser.loggedUser.firstName
        lastNameTF.text = LoggedInUser.loggedUser.lastName
        emailTF.text = LoggedInUser.loggedUser.email
        passwordTF.text = LoggedInUser.loggedUser.password
        confirmPasswordTF.text = LoggedInUser.loggedUser.password
        
        if let gender = LoggedInUser.loggedUser.gender{
            mfSelector.selectedSegmentIndex = gender
        } else {
            mfSelector.selectedSegmentIndex = 0
        }
        
        if let age = LoggedInUser.loggedUser.age {
            if age != "0" {
                ageTF.text = age
            }
        }
        
        // Setting up tap recognition
        
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        ageTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
        confirmPasswordTF.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        
        self.view.addGestureRecognizer(tap)
        
    }
    
    func handleTap() {
        self.firstNameTF.resignFirstResponder()
        self.lastNameTF.resignFirstResponder()
        self.ageTF.resignFirstResponder()
        self.emailTF.resignFirstResponder()
        self.passwordTF.resignFirstResponder()
        self.confirmPasswordTF.resignFirstResponder()
    }
    

    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        // Checking data conditions i.e. all fields full, email valid, passwords matching/long enough
        
        if firstNameTF.text?.characters.count == 0 || lastNameTF.text?.characters.count == 0 || ageTF.text?.characters.count == 0 || emailTF.text?.characters.count == 0 || passwordTF.text?.characters.count == 0 || confirmPasswordTF.text?.characters.count == 0 {
            displayAlertMessage(alertMessage: "All fields are required")
        } else if passwordTF.text != confirmPasswordTF.text {
            displayAlertMessage(alertMessage: "Passwords do match")
        } else if  (passwordTF.text?.characters.count)! < 8 || (confirmPasswordTF.text?.characters.count)! < 8 {
            displayAlertMessage(alertMessage: "Password must be at least 8 characters long")
        } else if !validateEmail(candidate: emailTF.text!){
            displayAlertMessage(alertMessage: "Please enter a valid email address")
        } else {
            
            LoggedInUser.loggedUser.customInit(phoneNumber: LoggedInUser.loggedUser.phoneNumber!, password: passwordTF.text!, firstName: firstNameTF.text!, lastName: lastNameTF.text!, email: emailTF.text!)
            
            LoggedInUser.loggedUser.gender = mfSelector.selectedSegmentIndex
            LoggedInUser.loggedUser.age = ageTF.text
            
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            
            request.returnsObjectsAsFaults = false
            
            do {
                let userArray:[User] = try context.fetch(User.fetchRequest())
                
                if userArray.count > 0 {
                    
                    for user in userArray {
                        if LoggedInUser.loggedUser.phoneNumber == user.phoneNumber{
                            
                            user.setValue(firstNameTF.text, forKey: "firstName")
                            user.setValue(lastNameTF.text, forKey: "lastName")
                            user.setValue(ageTF.text, forKey: "age")
                            user.setValue(emailTF.text, forKey: "email")
                            user.setValue(passwordTF.text, forKey: "password")
                            
                            let gender:String = String(mfSelector.selectedSegmentIndex)
                            
                            user.setValue(gender, forKey: "gender")
                            
                            do {
                                try context.save()
                            } catch {
                                displayAlertMessage(alertMessage: "Unable to save data")
                            }
                        }
                    }
                }
            } catch {
                displayAlertMessage(alertMessage: "Unable to save data")
            }
        }
        
        displayAlertMessageWithDismiss(alertMessage: "Changes successfully saved")
    }
    
    
    func displayAlertMessageWithDismiss(alertMessage: String) {
        
        let alert = UIAlertController(title:"Alert", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okButton = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:  { action in
            self.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(okButton)
        self.present(alert, animated: true, completion:nil)
    }
    
    
    // Reset logged user to nil and segue to log in page
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        
        LoggedInUser.loggedUser.customInit(phoneNumber: nil, password: nil, firstName: nil, lastName: nil, email: nil)
        LoggedInUser.loggedUser.age = nil
        LoggedInUser.loggedUser.gender = nil
        
        performSegue(withIdentifier: "LogOut", sender: self)
    }

}
