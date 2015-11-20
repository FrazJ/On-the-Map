//
//  OTMAPIConvenience.swift
//  On the Map
//
//  Created by Frazer Hogg on 25/10/2015.
//  Copyright © 2015 HomeProjects. All rights reserved.
//

import Foundation

extension OTMAPIClient {
    
    
    func authenticateWithViewController(username: String, password: String, completionHandler: (result: String?, error: NSError?) -> Void) {
        
        postSession(username, password: password) { (result, error) in
            
            /* GUARD: Was there an error? */
            guard error == nil else {
                completionHandler(result: nil, error: error)
                return
            }
            
            completionHandler(result: result, error: nil)
        }
    }
    
    
    
    func postSession(username: String, password: String, completionHandler: (result: String?, error: NSError?) -> Void) {
        
        let method = Methods.Session
        
        let jsonBody : [String:[String:AnyObject]] = [
                JSONBodyKeys.Udacity : [
                JSONBodyKeys.Username : username,
                JSONBodyKeys.Password : password
            ],
        ]
        
        taskForPostMethod(method, jsonBody: jsonBody) { (JSONResult, error) in
        
            /* GUARD: Was there an error? */
            guard error == nil else {
                completionHandler(result: nil, error: error)
                return
            }
            
            if let dictionary = JSONResult[JSONResponseKeys.Account ] as? [String:AnyObject] {
                if let result = dictionary[JSONResponseKeys.Key] as? String {
                    completionHandler(result: result, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "postSession parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse session"]))
                }
            } else {
                completionHandler(result: nil, error: NSError(domain: "postSession parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse session"]))
            }
        }
    }
    
    
    func deleteSession(completionHandler: (result: AnyObject?, error: NSError?) -> Void) {
        
        let method = Methods.Session
        
        taskForDeleteMethod(method) {(JSONResult, error) in
         
            /* GUARD: Was there an error? */
            guard error == nil else {
                completionHandler(result: nil, error: error)
                return
            }
            
            if let dictionary = JSONResult[JSONResponseKeys.Session ] as? [String:AnyObject] {
                if let result = dictionary[JSONResponseKeys.ID] as? String {
                    completionHandler(result: result, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "deleteSession", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not delete session"]))
                }
            } else {
                completionHandler(result: nil, error: NSError(domain: "deleteSession", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not delete session"]))
            }
        }
    }
    
    
    func getStudentLocations(completionHandler: (result: [[String:AnyObject]]?, error: NSError?) -> Void) {
        
        taskForGetMethod(Methods.StudentLocation) {(JSONResult, error) in
        
            /* GUARD: Was there an error? */
            guard error == nil else {
                completionHandler(result: nil, error: error)
                return
            }
            
            if let results = JSONResult[JSONResponseKeys.Results] as? [[String:AnyObject]] {
                completionHandler(result: results, error: nil)
            } else {
                completionHandler(result: nil, error: NSError(domain: "getStudentLocations", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse student data"]))
            }
        }
    }
    
    func postStudentLocation(jsonBody: [String:AnyObject], completionHandler: (result: AnyObject?, error: NSError?) -> Void) {
        
        let method = Methods.StudentLocation
//        let JSONBody = [
//            "uniqueKey": "1234",
//            "firstName": "John",
//            "lastName": "Doe",
//            "mapString": "Mountain View, CA",
//            "mediaURL": "https://udacity.com",
//            "latitude": 37.386052,
//            "longitude": -122.083851
//        ]
        
        taskForPostMethod(method, jsonBody: jsonBody) { (JSONResult, error) in
            
            /* GUARD: Was there an error? */
            guard error == nil else {
                completionHandler(result: nil, error: error)
                return
            }
            
            if let result = JSONResult[JSONResponseKeys.ObjectID] as? String {
                completionHandler(result: result, error: nil)
                print(result)
            } else {
                completionHandler(result: nil, error: NSError(domain: "postStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse student location"]))
            }
        }
    }
    
    func getUserData(userID: String, completionHandler: (result: [String]?, error: NSError?) -> Void) {
        
        let method = Methods.Users + userID
        
        taskForGetMethod(method) {(JSONResult, error) in
            
            /* GUARD: Was there an error? */
            guard error == nil else {
                completionHandler(result: nil, error: error)
                return
            }
            
            if let dictionary = JSONResult[JSONResponseKeys.User] as? [String:AnyObject] {
                
                var result = [String]()
                
                if let firstName = dictionary[JSONResponseKeys.First_Name] as? String {
                    result.append(firstName)
                    if let lastName = dictionary[JSONResponseKeys.Last_Name] as? String {
                        result.append(lastName)
                        completionHandler(result: result, error: nil)
                    } else {
                        completionHandler(result: nil, error: NSError(domain: "getUserData parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse user data : Last name"]))
                    }
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getUserData parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse user data : First name"]))
                }
            }
        }
    }
}
