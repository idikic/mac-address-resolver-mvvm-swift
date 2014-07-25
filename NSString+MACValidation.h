//
//  NSString+MACValidation.h
//  M@C
//
//  Created by iki on 8/1/13.
//  Copyright (c) 2013 iki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MACValidation)

-(BOOL) isValidMacAddressOUI;
-(BOOL) isValidMacAddress;

@end
