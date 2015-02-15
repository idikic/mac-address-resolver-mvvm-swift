//
//  SimplePingHelper.h
//  PingTester
//
//  Created by Chris Hulbert on 18/01/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimplePing.h"

typedef void (^CompletionHandler)(BOOL success);

@interface SimplePingHelper : NSObject <SimplePingDelegate>

+ (void)ping:(NSString*)address completionHandler:(CompletionHandler)handler;

@end
