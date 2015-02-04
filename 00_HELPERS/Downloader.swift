//
//  Downloader.swift
//  M.A.C.
//
//  Created by iki on 24/07/14.
//  Copyright (c) 2014 Iki. All rights reserved.
//

import UIKit
import SwiftyJSON

class Downloader {

    typealias JSONCompletion = JSON -> ()
    class func downloadJSON(macAddress: String, completionHandler: JSONCompletion) {

        let baseURL = "http://www.macvendorlookup.com/api/v2/"
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session: NSURLSession = NSURLSession(configuration: config)

        let task = session.dataTaskWithURL(NSURL(string: baseURL + macAddress)!) {
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
    
    private class func parseJSON(data: NSData, completionHandler:JSONCompletion) {

        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0), {
            () -> () in
            // Do a JSON parsing using SwiftyJSON
            var parsedJSON = JSON(data: data)
            // Dispatch on MAIN THREAD
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler(parsedJSON)
            }
        })
    }
}
