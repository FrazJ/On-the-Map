//
//  OTMAPIConstants.swift
//  On the Map
//
//  Created by Frazer Hogg on 25/10/2015.
//  Copyright © 2015 HomeProjects. All rights reserved.
//

import Foundation

extension OTMAPIClient {
    
    //MARK: Constants
    struct Constants {
        
        static let UdacityBaseURL = "https://www.udacity.com/api/"
        static let ParseBaseURL = ""
        
    }
    
    
    //MARK: Methods
    struct Methods {
        
        //MARK: -Authentication
        static let Session = "session"
        
        //MARK: -Public user data
        static let Users = "users/<user_id>"
        
    }
    
    
    //MARK: URL Keys
    struct URLKeys {
        
        //MARK: -UserID
        static let UserID = "<user_id>"
        
    }
    
    
    //MARK: JSON Body Keys
    struct JSONBodyKeys {
        
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        
    }
    
    
    //MAK: JSON Response Keys
    struct JSONResponseKeys {
        
        //MARK: -Account
        static let Account = "account"
        static let Registered = "registered"
        static let Key = "key"
        
        //Mark: -Session
        static let Session = "session"
        static let ID = "id"
        static let Expiration = "expiration"
        
    }
    
    
}