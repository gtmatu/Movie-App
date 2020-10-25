//
//  SignUpFlowViewController.swift
//  DemoApp
//
//  Created by Sofia Sarjanovic on 20/07/2017.
//  Copyright © 2017 Mateo Sarjanovic. All rights reserved.
//

import UIKit
import CoreData

class SignUpFlowViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up tap detection to exit text fields
        
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        self.view.addGestureRecognizer(tap)

    }
    
    func handleTap(){
        self.passwordTextField.resignFirstResponder()
        self.confirmPasswordTextField.resignFirstResponder()
    }


    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!

    
    @IBAction func passwordInput(_ sender: Any) {
        
        let password = passwordTextField.text
        let confirmPassword = confirmPasswordTextField.text
        
        // Checking if passwords match and are long enough, if conditions met assigned to logged user
        
        if password != confirmPassword {
            displayAlertMessage(alertMessage: "Passwords do not match")
        } else if (password?.characters.count)! < 8 {
            displayAlertMessage(alertMessage: "Password too short, must be at least 8 characters")
        } else{
            LoggedInUser.loggedUser.password = password
            performSegue(withIdentifier: "passwordComplete", sender: self)
        }
    }

}
