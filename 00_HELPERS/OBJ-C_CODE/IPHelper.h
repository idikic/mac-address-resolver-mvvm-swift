//
//  NetworkUtility.h
//  M.A.C.
//
//  Created by Ivan Dikic on 8/1/13.
//  Copyright (c) 2013 iki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPHelper : NSObject

+ (NSString *)ip2mac:(NSString *)ipAddress withBlock:(void (^)(NSString *))block;

@end

/*
http://stackoverflow.com/questions/2189200/get-router-mac-without-system-call-for-arp-in-objective-c
http://stackoverflow.com/questions/10395041/getting-arp-table-on-iphone-ipad
http://stackoverflow.com/questions/2258172/how-do-i-query-the-arp-table-on-iphone
*/