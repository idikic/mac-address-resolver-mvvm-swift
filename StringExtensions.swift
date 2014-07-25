//
//  ValidMACAddres.swift
//  M.A.C.
//
//  Created by iki on 25/07/14.
//  Copyright (c) 2014 Iki. All rights reserved.
//

import UIKit
import Foundation

extension String {
   
    func isValidMacAddress(macAddress: String) -> Bool {
    
        // CONVERT STRING TO const char *
        var mac = macAddress.cStringUsingEncoding(NSASCIIStringEncoding)
        
        
        var i = 0;
        var s = 0;
        
        // POINTER TO RAW MEMORY VALUE OF const char *
        var tempPointer: UnsafePointer<CChar>?
        
        // BRIDGE ??
        mac?.withUnsafePointerToElements() {
            
            (let addrBuffPtr : UnsafePointer<CChar>) -> () in
            
            var maxSize = mac?.count
            var newSize = 0
            

            // USE POINTER TO MEMORY
            tempPointer = addrBuffPtr
            
            while (maxSize != newSize) {
                
                // use pointer to memory
                var xN:CChar = tempPointer!.memory
                
                if isxdigit(Int32(xN)) != 0 {
                    i++
                    println(i)
                    
                // 58 == ":"      45 == "-"
                } else if xN == 58 || xN == 45 {
                    
                    if i == 0 || i / 2 - 1 != s {
                        break
                    }
                    
                    ++s
                    
                } else if xN != 0 {
                    s = -1;
                }
                
                println("The ASCII value at index \(newSize) is \(xN)")
                
                // GET NEXT ELEMENT OF const char *
                tempPointer = tempPointer!.successor()
                
                ++newSize
                
            }
            
            
        }
        println("VALUE OF I: \(i)")
        println("VALUE OF S: \(s)")
        
        // DESTROY UnsafePointer
        // tempPointer
        return (i == 12 && (s == 5 || s == 0))
    }
}


/*
//CHECKS VALIDITY OF A COMPLETE MAC ADDRESS
//BUT WE ONLY USE FIRST SIX DIGITS
//return (i == 12 && (s == 5 || s == 0));
return (i == 6 && (s == 2 || s == 0));
*/