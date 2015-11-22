//
//  UdacityConvenience.swift
//  On the Map
//
//  Created by Frazer Hogg on 25/10/2015.
//  Copyright © 2015 HomeProjects. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    ///Function that POSTs a new session
    func postSession(username: String, password: String, completionHandler: (result: String?, error: NSError?) -> Void) {
        
        let method = Methods.Session
        
        let jsonBody = [
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
            
            if let dictionary = JSONResult![JSONResponseKeys.Account ] as? [String:AnyObject] {
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
    
    ///Function that DELETEs the current session
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
    
    ///Function that GETs the first and last name for the user
    func getUserData(userID: String, completionHandler: (result: [String]?, error: NSError?) -> Void) {
        
        let method = Methods.Users + userID
        
        taskForGetMethod(method) {(JSONResult, error) in
            
            /* GUARD: Was there an error? */
            guard error == nil else {
                completionHandler(result: nil, error: error)
                return
            }
            
            if let dictionary = JSONResult[JSONResponseKeys.User] as? [String:AnyObject] {
                /* Array for the first and last name of the user */
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
