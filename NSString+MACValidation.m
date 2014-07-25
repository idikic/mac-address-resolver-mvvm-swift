//
//  NSString+MACValidation.m
//  M@C
//
//  Created by iki on 8/1/13.
//  Copyright (c) 2013 iki. All rights reserved.
//

#import "NSString+MACValidation.h"

@implementation NSString (MACValidation)

-(BOOL) isValidMacAddressOUI
{
    //int isValidMacAddress(const char* mac) {
    const char *mac = [self cStringUsingEncoding:NSASCIIStringEncoding];
    
    int i = 0;
    int s = 0;
    
    while (*mac) {
        if (isxdigit(*mac)) {
            i++;
        }
        else if (*mac == ':' || *mac == '-') {
            
            if (i == 0 || i / 2 - 1 != s)
                break;
            
            ++s;
        }
        else {
            s = -1;
        }
        
        
        ++mac;
    }
    
    //CHECKS VALIDITY OF A COMPLETE MAC ADDRESS
    //BUT WE ONLY USE FIRST SIX DIGITS
    //return (i == 12 && (s == 5 || s == 0));
    return (i == 6 && (s == 2 || s == 0));
}

-(BOOL) isValidMacAddress
{
    const char *mac = [self cStringUsingEncoding:NSASCIIStringEncoding];
    
    int i = 0;
    int s = 0;
    
    while (*mac) {
        if (isxdigit(*mac)) {
            i++;
        }
        else if (*mac == ':' || *mac == '-') {
            
            if (i == 0 || i / 2 - 1 != s)
                break;
            
            ++s;
        }
        else {
            s = -1;
        }
        
        
        ++mac;
    }
    
    //CHECKS VALIDITY OF A COMPLETE MAC ADDRESS
    return (i == 12 && (s == 5 || s == 0));

}
@end



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
















