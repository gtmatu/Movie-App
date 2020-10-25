//
//  SignInViewController.swift
//  DemoApp
//
//  Created by Sofia Sarjanovic on 21/07/2017.
//  Copyright © 2017 Mateo Sarjanovic. All rights reserved.
//

import UIKit
import CoreData

class SignInViewController: UIViewController, UITextFieldDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up tap detection and displaying phone number
        
        self.phoneNumberTextField.delegate = self
        self.passwordTextField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        self.view.addGestureRecognizer(tap)
        
        phoneNumberTextField.text = LoggedInUser.loggedUser.phoneNumber

    }
    
    func handleTap(){
        self.phoneNumberTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }

    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    
    @IBAction func LogInAttempted(_ sender: UIButton) {
        
        let passwordInput = passwordTextField.text
        
        if passwordInput == LoggedInUser.loggedUser.password{
            performSegue(withIdentifier: "Password Correct", sender: self)
        } else {
            displayAlertMessage(alertMessage: "Password incorrect")
        }
        
    }
    
    

}
