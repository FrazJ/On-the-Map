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

extension StudentInformation {
    
}



//OTMAPIClient.sharedInstance().getStudentLocations {(result, error) in
//    
//    guard error == nil else {
//        print("There was an error fetching the student locations: \(error)")
//        return
//    }
//    
//    var studentArray = [StudentInformation]()
//    
//    for s in result! {
//        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        
//        let objectID = s[OTMAPIClient.JSONResponseKeys.ObjectID] as! String
//        let uniqueKey = s[OTMAPIClient.JSONResponseKeys.UniqueKey] as! String?
//        let firstName = s[OTMAPIClient.JSONResponseKeys.FirstName] as! String
//        let lastName = s[OTMAPIClient.JSONResponseKeys.LastName] as! String
//        let mapString = s[OTMAPIClient.JSONResponseKeys.MapString] as! String
//        let mediaURL = s[OTMAPIClient.JSONResponseKeys.MediaURL] as! String
//        let latitude = s[OTMAPIClient.JSONResponseKeys.Latitude] as! Double
//        let longitude = s[OTMAPIClient.JSONResponseKeys.Latitude] as! Double
//        let createdAt = dateFormatter.dateFromString(s[OTMAPIClient.JSONResponseKeys.CreatedAt] as! String)
//        let updatedAt = dateFormatter.dateFromString(s[OTMAPIClient.JSONResponseKeys.UpdatedAt] as! String)
//        
//        let newStudent = StudentInformation(
//            objectID: objectID,
//            uniqueKey: uniqueKey,
//            firstName: firstName,
//            lastName: lastName,
//            mapString: mapString,
//            mediaURL: mediaURL,
//            latitude: latitude,
//            longitude: longitude,
//            createdAt: createdAt!,
//            updatedAt: updatedAt!
//        )
//        
//        studentArray.append(newStudent)
//    }
//    
//    print("Array: \(studentArray)")
