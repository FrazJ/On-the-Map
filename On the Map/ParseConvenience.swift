//
//  ParseConvenience.swift
//  On the Map
//
//  Created by Frazer Hogg on 22/11/2015.
//  Copyright © 2015 HomeProjects. All rights reserved.
//

import Foundation
import UIKit

extension ParseClient {
    
    ///Function that GETs the last 100 student locations created
    func getStudentLocations(completionHandler: (result: [[String:AnyObject]]?, error: NSError?) -> Void) {
        
        taskForGetMethod(Methods.StudentLocation, parameters: nil) {(JSONResult, error) in

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
    
    func queryForAStudent(completionHandler: (result: [[String:AnyObject]]?, error: NSError?) -> Void) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let parameters = [ParameterKeys.Where : "{\"\(ParameterKeys.UniqueKey)\":\"\(appDelegate.userID)\"}"]
        
        taskForGetMethod(Methods.StudentLocation, parameters: parameters) {(JSONResult, error) in
            
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

    
    ///Function that POSTs a students location
    func postStudentLocation(jsonBody: [String:AnyObject], completionHandler: (result: AnyObject?, error: NSError?) -> Void) {
        
        let method = Methods.StudentLocation
        
        taskForPostMethod(method, jsonBody: jsonBody) { (JSONResult, error) in
            
            /* GUARD: Was there an error? */
            guard error == nil else {
                completionHandler(result: nil, error: error)
                return
            }
            
            if let result = JSONResult[JSONResponseKeys.ObjectID] as? String {
                completionHandler(result: result, error: nil)
            } else {
                completionHandler(result: nil, error: NSError(domain: "postStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse student location"]))
            }
        }
    }
    
    
    ///Function that PUTs a students location
    func putStudentLocation(parameters: String, jsonBody: [String:AnyObject], completionHandler: (result: AnyObject?, error: NSError?) -> Void) {
        
        let method = Methods.StudentLocation
        
        taskForPutMethod(method, parameters: parameters, jsonBody: jsonBody){ (JSONResult, error) in
            
            /* GUARD: Was there an error? */
            guard error == nil else {
                completionHandler(result: nil, error: error)
                return
            }
            
            if let result = JSONResult[JSONResponseKeys.UpdatedAt] as? String {
                completionHandler(result: result, error: nil)
            } else {
                completionHandler(result: nil, error: NSError(domain: "postStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse student location"]))
            }
        }
    }

}