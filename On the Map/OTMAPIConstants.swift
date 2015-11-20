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
        static let ParseBaseURL = "https://api.parse.com/1/classes/"
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ParseAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    
    //MARK: Methods
    struct Methods {
        //MARK: -Authentication
        static let Session = "session"
        //MARK: -Public user data
        static let Users = "users/"
        //MARK: -Student locations
        static let StudentLocation = "StudentLocation"
    }
    
    
    //MARK: JSON Body Keys
    struct JSONBodyKeys {
        
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        
        //MARK: -StudentLocation
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        
    }
    
    
    //MAK: JSON Response Keys
    struct JSONResponseKeys {
        
        //MARK: -Account
        static let Account = "account"
        static let Registered = "registered"
        static let Key = "key"
        
        //MARK: -Session
        static let Session = "session"
        static let ID = "id"
        static let Expiration = "expiration"
        
        //MARK: -StudentLocations
        static let Results = "results"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectID = "objectId"
        static let UniqueKey = "uniqueKey"
        static let UpdatedAt = "updatedAt"
        static let CreatedAt = "createdAt"
        
        //MARK: -User Data
        static let User = "user"
        static let Last_Name = "last_name"
        static let First_Name = "first_name"
    }
    
}