//
//  Downloader.swift
//  M.A.C.
//
//  Created by iki on 24/07/14.
//  Copyright (c) 2014 Iki. All rights reserved.
//

import UIKit

class Downloader {
   
    private let URL: NSURL
    private lazy var config = NSURLSessionConfiguration.defaultSessionConfiguration()
    private lazy var session: NSURLSession = NSURLSession(configuration: self.config)
    
    init (url: String) {
    
        self.URL = NSURL(string: url)!
    }
    
    func downloadJSON(completionHandler: (Array<AnyObject>?) -> ()) {
    
        let task = session.dataTaskWithURL(URL) {
        
        (let data, let response, let error) in
            
            if let httpResponse = response as? NSHTTPURLResponse {
            
                println("Got some data")
                
                switch(httpResponse.statusCode) {
                
                case 200:
                    println("Got 200")
                    self.parseJSON(data, completionHandler: completionHandler)
                    
                default:
                    println("Got an HTTP \(httpResponse.statusCode)")
                
                }
            
            }
            
        
        }
        task.resume()
    
    
    }
    
    private func parseJSON(data: NSData, completionHandler:(Array<AnyObject>?) -> ()) {
        
        // Do a PARSING of JSON on background thread
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0), {
            
            () -> () in
            
            // Do a JSON parsing
            var parsedJSON = NSJSONSerialization.JSONObjectWithData(data,
                options: .AllowFragments,
                error: nil)
                as Array<Dictionary<String, AnyObject>>
            
            // Dispatch on MAIN THREAD
            dispatch_async(dispatch_get_main_queue()) {
            
                completionHandler(parsedJSON)
            
            }
            
            
            })
        
    }
    
}
