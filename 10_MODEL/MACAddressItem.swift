//
//  MACAddressItem.swift
//  M.A.C.
//
//  Created by iki on 16/07/14.
//  Copyright (c) 2014 Iki. All rights reserved.
//

import UIKit

class MACAddressItem: NSObject , NSCoding {

    // MARK: Properties
    let macAddress: String!
    let dateCreated: NSDate!
    let company: String?
    let department: String?
    let address1: String?
    let address2: String?
    let country: String?
    let locationOfDevice: String?

    // MARK: Lifecycle
    init?(macAddress: String) {

        // When dealing with NSObject we need to call super.init() before
        // returning nil from within failable initializer('init?').
        // If not compiler will complain that all stored properties must
        // have an initial value.
        // For all other cases, we have to call super.init() after all of the stored
        // properties have an initial value.
        super.init()
        if macAddress.isEmpty {
            return nil
        }

        self.macAddress = macAddress
        self.dateCreated = NSDate()
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

    // MARK: Public Interface
    func description() -> String {
        var stringDescription: String = "I'am MAC:\(self.macAddress), created at:\(self.dateCreated)"
        return stringDescription
    }
}
