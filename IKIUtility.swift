//
//  IKIUtility.swift
//  M.A.C.
//
//  Created by iki on 18/07/14.
//  Copyright (c) 2014 Iki. All rights reserved.
//

import UIKit

class IKIUtility: NSObject {
   
    class var sharedStore : IKIUtility {
        
    struct Singleton {
        
        // lazily initiated, thread-safe from "let"
        static let instance = IKIUtility()
        
        }
        return Singleton.instance
    }
    
    
    func dateToString(date: NSDate) -> String {
    
        return NSDateFormatter.localizedStringFromDate(date, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
    }

}
