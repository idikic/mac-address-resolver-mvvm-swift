//
//  MACAddressStore.swift
//  M.A.C.
//
//  Created by iki on 17/07/14.
//  Copyright (c) 2014 Iki. All rights reserved.
//

import UIKit

class MACAddressStore: NSObject {
    
    class var sharedStore : MACAddressStore {
    
        struct Singleton {
        
            // lazily initiated, thread-safe from "let"
            static let instance = MACAddressStore()
            
        }
        return Singleton.instance
    }
    
    
    var _privateItems = [MACAddressItem]()
    
    // The allItems property can't be changed by other objects
    var allItems: [MACAddressItem] {
    
        return _privateItems
    
    }
    
    
    override init() {
    
        super.init()
        
        let path = itemArchivedPath
        
        // Returns "nil" if there is no file at the path
        let unarchivedItems : AnyObject! = NSKeyedUnarchiver.unarchiveObjectWithFile(path)
        
        // If there were archived items saved, set _privateItems for the shared store equal to that
        if unarchivedItems != nil {
        
            _privateItems = unarchivedItems as Array<MACAddressItem>
        
        }
        
        delayOnMainQueueFor(numberOfSeconds: 0.1, action: {
        
            assert(self === MACAddressStore.sharedStore, "Only one instance of ItemStore allowed!")
            
        })
        
        
    }
    
    func createItem(macAddress: String!) -> MACAddressItem {
    
        let item = MACAddressItem(macAddress: macAddress)
        _privateItems.append(item)
        
        return item
    
    }
    
    func removeItem(macAddressItem: MACAddressItem!) {
    
        for (index, element) in enumerate(_privateItems) {
        
            if element === macAddressItem {
            
                _privateItems.removeAtIndex(index)
            }
        
        }
    }
    
    var itemArchivedPath: String {
    
        // Create a filepath for archiving
        let documentDirectories = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,
                                                                        NSSearchPathDomainMask.UserDomainMask, true)
            
        // Get the one document directory from that list
        let documentDirectory = documentDirectories[0] as String
            
        // append with the items.archive file name, then return
        return documentDirectory.stringByAppendingPathComponent("items.archive")
    
    
    }
    
    func saveChanges() -> Bool {
    
        let path = itemArchivedPath
        
        // Return "true" on success
        return NSKeyedArchiver.archiveRootObject(_privateItems, toFile: path)
    }
    
    func delayOnMainQueueFor(numberOfSeconds delay:Double, action closure:()->()) {
       
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
           
            dispatch_get_main_queue()) {
                closure()
        }
        
    }
    
   
}
