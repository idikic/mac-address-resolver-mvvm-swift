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
    
        self.URL = NSURL.URLWithString(url)
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
        
        // Do a JSON parsing
        completionHandler(nil)
    
    }
    
}
