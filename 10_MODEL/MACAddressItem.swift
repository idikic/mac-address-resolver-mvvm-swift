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
  var company: String?
  var address1: String?
  var address2: String?
  var country: String?
  var locationOfDevice: String?
  override var description: String {
    get {
      var stringDescription: String
        = "I'am MAC:\(self.macAddress), created at:\(self.dateCreated)"
      return stringDescription
    }
  }

  // MARK: Lifecycle
  init?(macAddress: String) {
  
    self.macAddress = macAddress
    self.dateCreated = NSDate()

    super.init()

    if macAddress.isEmpty {
      return nil
    }

  }

  required init(coder aDecoder: NSCoder) {
    self.macAddress = aDecoder.decodeObjectForKey("macAddress") as! String
    self.company = aDecoder.decodeObjectForKey("company") as? String
    self.address1 = aDecoder.decodeObjectForKey("address1") as? String
    self.address2 = aDecoder.decodeObjectForKey("address2") as? String
    self.country = aDecoder.decodeObjectForKey("country") as? String
    self.locationOfDevice = aDecoder.decodeObjectForKey("locationOfDevice") as? String
    self.dateCreated = aDecoder.decodeObjectForKey("dateCreated") as! NSDate
  }

  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(macAddress, forKey: "macAddress")
    aCoder.encodeObject(company!, forKey: "company")
    aCoder.encodeObject(address1!, forKey: "address1")
    aCoder.encodeObject(address2!, forKey: "address2")
    aCoder.encodeObject(country!, forKey: "country")
    aCoder.encodeObject(locationOfDevice!, forKey: "locationOfDevice")
    aCoder.encodeObject(dateCreated, forKey: "dateCreated")
  }

}
