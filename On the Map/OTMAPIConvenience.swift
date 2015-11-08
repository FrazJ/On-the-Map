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
            if error == error {
                completionHandler(result: nil, error: error)
            } else {
                completionHandler(result: result, error: nil)
            }
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
        
        taskForPostMethod(method, jsonBody: jsonBody) { JSONResult, error in
        
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                if let dictionary = JSONResult[JSONResponseKeys.Session ] as? [String:AnyObject] {
                    if let result = dictionary[JSONResponseKeys.ID] as? String {
                        completionHandler(result: result, error: nil)
                    } else {
                        completionHandler(result: nil, error: NSError(domain: "postSession parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse session"]))
                    }
                } else {
                    completionHandler(result: nil, error: NSError(domain: "postSession parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse session"]))
                }
            }
        }
    }
    
    
    func getStudentLocations(completionHandler: (result: [[String:AnyObject]]?, error: NSError?) -> Void) {
        
        let parameters = [String:AnyObject]()
        
        taskForGetMethod(Methods.StudentLocation, parameters: parameters) {(JSONResult, error) in
        
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                if let results = JSONResult[JSONResponseKeys.Results] as? [[String:AnyObject]] {
                    completionHandler(result: results, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getStudentLocations", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse session"]))
                }
            }
        
        }
        
    }
}