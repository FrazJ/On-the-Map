//
//  StudentInformation.swift
//  On the Map
//
//  Created by Frazer Hogg on 06/11/2015.
//  Copyright © 2015 HomeProjects. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    
    let objectID : String
    let uniqueKey : String?
    let firstName : String
    let lastName : String
    let mapString : String
    let mediaURL : String
    let latitude : Double
    let longitude : Double
    let createdAt : NSDate
    let updatedAt : NSDate
    
    init(dictionary : [String:AnyObject]) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        self.objectID = dictionary[OTMAPIClient.JSONResponseKeys.ObjectID] as! String
        self.uniqueKey = dictionary[OTMAPIClient.JSONResponseKeys.UniqueKey] as! String?
        self.firstName = dictionary[OTMAPIClient.JSONResponseKeys.FirstName] as! String
        self.lastName = dictionary[OTMAPIClient.JSONResponseKeys.LastName] as! String
        self.mapString = dictionary[OTMAPIClient.JSONResponseKeys.MapString] as! String
        self.mediaURL = dictionary[OTMAPIClient.JSONResponseKeys.MediaURL] as! String
        self.latitude = dictionary[OTMAPIClient.JSONResponseKeys.Latitude] as! Double
        self.longitude = dictionary[OTMAPIClient.JSONResponseKeys.Latitude] as! Double
        self.createdAt = dateFormatter.dateFromString(dictionary[OTMAPIClient.JSONResponseKeys.CreatedAt] as! String)!
        self.updatedAt = dateFormatter.dateFromString(dictionary[OTMAPIClient.JSONResponseKeys.UpdatedAt] as! String)!
    }
    
}
