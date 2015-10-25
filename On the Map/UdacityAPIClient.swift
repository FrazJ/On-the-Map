//
//  UdacityAPIClient.swift
//  On the Map
//
//  Created by Frazer Hogg on 25/10/2015.
//  Copyright © 2015 HomeProjects. All rights reserved.
//

import Foundation

class UdacityAPIClient : NSObject {
    
    //MARK: Properties
    
    /* Shared session */
    var session: NSURLSession
    
    /* Authentication state */
    var sessionID : String? = nil
    var userID : Int? = nil
    
    
    //MARK: Initialiser
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    
    //MARK: POST
    func taskForPost(method: String, jsonBody: [String:[String:AnyObject]], completionHandler: (result: AnyObject!, error : NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        //Not required for getting the session
        
        /* 2/3. Build the URL and configure the request*/
        let urlString = Constants.BaseURL + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
        
            /* GUARD: Was there an error? */
            guard error == nil else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            /* 5/6. Parse the data and use the data */
            UdacityAPIClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            
        }
        
        /* Start the request */
        task.resume()
        
        return task
        
    }
    
    
    //MARK: Helper methods

    ///Function that returns a single shared instance of the session
    class func sharedInstance() -> UdacityAPIClient {
        
        struct Singleton {
            static var sharedInstance = UdacityAPIClient()
        }
        
        return Singleton.sharedInstance
        
    }

    ///Function that returns a Foundation object from raw JSON
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(result: parsedResult, error: nil)
        
    }
    
}