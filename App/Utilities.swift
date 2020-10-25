//
//  Utilities.swift
//  DemoApp
//
//  Created by Sofia Sarjanovic on 24/07/2017.
//  Copyright © 2017 Mateo Sarjanovic. All rights reserved.
//

import UIKit

extension UIViewController {

    func displayAlertMessage (alertMessage: String){
        
        let alert = UIAlertController(title:"Alert", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okButton = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(okButton)
        
        self.present(alert, animated: true, completion:nil)
    }
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    
}

