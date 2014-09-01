//
//  MACAddressItem.swift
//  M.A.C.
//
//  Created by iki on 16/07/14.
//  Copyright (c) 2014 Iki. All rights reserved.
//

import UIKit

class MACAddressItem: NSObject , NSCoding {
    
    let macAddress: String!
    let company: String?
    let department: String?
    let address1: String?
    let address2: String?
    let country: String?
    let locationOfDevice: String?
    let dateCreated: NSDate!
    
    
    init(macAddress: String) {
    
        self.macAddress = macAddress
        self.company = "unknown"
        self.dateCreated = NSDate.date()
        
        /*
            In Apple's "Intermediate Swift" video (you can find it in Apple Developer video 
            resource page https://developer.apple.com/videos/wwdc/2014/), 
            at about 28:40, it is explicit said that all initializers 
            in super class must be called AFTER you initialize your instance variables.
        */
        
        super.init()
        
        
        
    }
    
    
    func description_iki() -> String {
    
        var stringDescription: String = "I'am MAC:\(self.macAddress), created at:\(self.dateCreated)"
        
        return stringDescription
    }
   
    func encodeWithCoder(aCoder: NSCoder) {
    
        aCoder.encodeObject(macAddress, forKey: "macAddress")
        aCoder.encodeObject(company!, forKey: "company")
        aCoder.encodeObject(department!, forKey: "department")
        aCoder.encodeObject(address1!, forKey: "address1")
        
        aCoder.encodeObject(address2!, forKey: "address2")
        aCoder.encodeObject(country!, forKey: "country")
        aCoder.encodeObject(locationOfDevice!, forKey: "locationOfDevice")
        aCoder.encodeObject(dateCreated, forKey: "dateCreated")
        
        
    }
    
    required init(coder aDecoder: NSCoder) {
    
        self.macAddress = aDecoder.decodeObjectForKey("macAddress") as String
        self.company = aDecoder.decodeObjectForKey("company") as? String
        self.department = aDecoder.decodeObjectForKey("department") as? String
        self.address1 = aDecoder.decodeObjectForKey("address1") as? String
        self.address2 = aDecoder.decodeObjectForKey("address2") as? String
        self.country = aDecoder.decodeObjectForKey("country") as? String
        self.locationOfDevice = aDecoder.decodeObjectForKey("locationOfDevice") as? String
        self.dateCreated = aDecoder.decodeObjectForKey("dateCreated") as NSDate
        
        
    
    }
}
