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
            addrBuffPtr.destroy()
        }
        println("VALUE OF I: \(i)")
        println("VALUE OF S: \(s)")
        
        // DESTROY UnsafePointer
        tempPointer?.destroy()
        return (i == 12 && (s == 5 || s == 0))
    }
}


/*
//  CHECKS VALIDITY OF A COMPLETE MAC ADDRESS
//  BUT WE ONLY USE FIRST SIX DIGITS
//  return (i == 12 && (s == 5 || s == 0));
//  return (i == 6 && (s == 2 || s == 0));
*/

/*

The code checks the following:

that the input string mac contains exactly 12 hexadecimal digits.
that, if a separator colon : appears in the input string, it only appears after an even number of hex digits.

It works like this:

i,which is the number of hex digits in mac, is initialized to 0.
The while loops over every character in the input string until either the string ends,
or 12 hex digits have been detected.

If the current character (*mac) is a valid hex digit,
then i is incremented, and the loop examines the next character.

Otherwise, the loop checks if the current character is a separator (colon or a dash);
if so, it verifies that there is one separator for every pair of hex digits.
Otherwise, the loop is aborted.

After the loop finishes, the function checks if 12 hex digits have been found,
and zero or exactly five separators, and returns the result.

If you don't want to accept separators, simply change the return statement to:

return (i == 12 && s == 0);


*/