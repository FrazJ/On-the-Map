//
//  ParseConstants.swift
//  On the Map
//
//  Created by Frazer Hogg on 22/11/2015.
//  Copyright © 2015 HomeProjects. All rights reserved.
//

import Foundation

extension ParseClient {
    
    //MARK: Constants
    struct Constants {
        static let ParseBaseURL = "https://api.parse.com/1/classes/"
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ParseAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    
    //MARK: Methods
    struct Methods {
        static let StudentLocation = "StudentLocation"
    }
    
    
    //MARK: JSON Body Keys
    struct JSONBodyKeys {
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
    }
}