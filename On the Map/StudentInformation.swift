//
//  StudentInformation.swift
//  On the Map
//
//  Created by Frazer Hogg on 06/11/2015.
//  Copyright © 2015 HomeProjects. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    //MARK: Properties
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
    static var studentData = [StudentInformation]()
    
    //MARK: Initialiaiser that takes a dictionary.
    init(dictionary : [String:AnyObject]) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        self.objectID = dictionary[ParseClient.JSONResponseKeys.ObjectID] as! String
        self.uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as! String?
        self.firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as! String
        self.lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as! String
        self.mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as! String
        self.mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as! String
        self.latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as! Double
        self.longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as! Double
        self.createdAt = dateFormatter.dateFromString(dictionary[ParseClient.JSONResponseKeys.CreatedAt] as! String)!
        self.updatedAt = dateFormatter.dateFromString(dictionary[ParseClient.JSONResponseKeys.UpdatedAt] as! String)!
    }
}
