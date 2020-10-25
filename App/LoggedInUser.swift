//
//  LoggedInUser.swift
//  DemoApp
//
//  Created by Sofia Sarjanovic on 21/07/2017.
//  Copyright © 2017 Mateo Sarjanovic. All rights reserved.
//

import UIKit

class LoggedInUser: NSObject {
    
    static var loggedUser = LoggedInUser()
    
    var phoneNumber:String?
    var password:String?
    var firstName:String?
    var lastName:String?
    var email:String?
    var gender:Int?
    var age:String?
    var userID:String?
    
    func customInit(phoneNumber: String?, password: String?, firstName: String?, lastName: String?, email: String?){
        self.phoneNumber = phoneNumber
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}
