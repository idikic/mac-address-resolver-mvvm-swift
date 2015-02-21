//
//  SimplePingHelper.m
//  PingTester
//
//  Created by Chris Hulbert on 18/01/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "SimplePingHelper.h"

@interface SimplePingHelper()

@property (nonatomic,strong) SimplePing* simplePing;
@property (nonatomic, copy) PingCompletionHandler completionHandler;

@end

@implementation SimplePingHelper

#pragma mark - Class

// Pings the address, and calls the completion handler when done.
// Completion handler must take a NSnumber which is a bool for success.
+ (void)ping:(NSString*)address completionHandler:(PingCompletionHandler)completionHandler
{
	// The helper retains itself through the timeout function
	[[[SimplePingHelper alloc] initWithAddress:address completionHandler:completionHandler] go];
}

#pragma mark - Lifecycle

- (void)dealloc
{
	self.simplePing = nil;
	self.completionHandler = nil;
}

- (instancetype)initWithAddress:(NSString*)address
              completionHandler:(PingCompletionHandler)completionHandler
{
	if (self = [self init])
    {
		self.simplePing = [SimplePing simplePingWithHostName:address];
		self.simplePing.delegate = self;
        self.completionHandler = completionHandler;
	}
	return self;
}

#pragma mark - Go

- (void)go
{
	[self.simplePing start];
	[self performSelector:@selector(endTime)
               withObject:nil
               afterDelay:1]; // This timeout is what retains the ping helper
}

#pragma mark - Finishing and timing out

// Called on success or failure to clean up
- (void)killPing
{
	[self.simplePing stop];
	self.simplePing = nil;
}

- (void)successPing
{
	[self killPing];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    self.completionHandler(YES);
#pragma clang diagnostic pop
	
}

- (void)failPing:(NSString*)reason
{
	[self killPing];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    self.completionHandler(NO);
#pragma clang diagnostic pop
	
}

// Called 1s after ping start, to check if it timed out
- (void)endTime
{
	if (self.simplePing)
    {   // If it hasn't already been killed, then it's timed out
		[self failPing:@"timeout"];
	}
}

#pragma mark - Pinger delegate

// When the pinger starts, send the ping immediately
- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address
{
	[self.simplePing sendPingWithData:nil];
}

- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error
{
	[self failPing:@"didFailWithError"];
}

- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet error:(NSError *)error
{
	// Eg they're not connected to any network
	[self failPing:@"didFailToSendPacket"];
}

- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet
{
	[self successPing];
}

@end
