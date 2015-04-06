//
//  NetworkUtility.m
//  M.A.C.
//
//  Created by Ivan Dikic on 8/1/13.
//  Copyright (c) 2013 iki. All rights reserved.
//

#import "IPHelper.h"

#if TARGET_IPHONE_SIMULATOR
#include <net/route.h>
#else
#include "route.h"
#endif
#include <sys/param.h>
#include <sys/file.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include "if_types.h"
#include "if_ether.h"
#include <netinet/in.h>
#include <arpa/inet.h>
#include <err.h>
#include <errno.h>
#include <netdb.h>
#include <paths.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>


@implementation IPHelper

+ (void)macAddressFromIPAddress:(NSString *)ipAddress
              completionHandler:(IPCompletionHandler)completionHandler
{
  NSString *macAddress = nil;

  in_addr_t ipAddressBaseType = [IPHelper convertIPAddress:ipAddress];
  size_t needed;

  char *buffer, *next;
  struct rt_msghdr *rtm;
  struct sockaddr_inarp *sin;
  struct sockaddr_dl *sdl;
  int mib[6];
  
  mib[0] = CTL_NET;
  mib[1] = PF_ROUTE;
  mib[2] = 0;
  mib[3] = AF_INET;
  mib[4] = NET_RT_FLAGS;
  mib[5] = RTF_LLINFO;
  
  if (sysctl(mib, sizeof(mib) / sizeof(mib[0]), NULL, &needed, NULL, 0) < 0) {
    err(1, "route-sysctl-estimate");
  }

  if ((buffer = (char*)malloc(needed)) == NULL) {
    err(1, "malloc");
  }

  if (sysctl(mib, sizeof(mib) / sizeof(mib[0]), buffer, &needed, NULL, 0) < 0) {
    err(1, "retrieval of routing table");
  }

  for (next = buffer; next < buffer + needed; next += rtm->rtm_msglen) {
    rtm = (struct rt_msghdr *)next;
    sin = (struct sockaddr_inarp *)(rtm + 1);
    sdl = (struct sockaddr_dl *)(sin + 1);
    
    if (ipAddressBaseType != sin->sin_addr.s_addr || sdl->sdl_alen < 6) {
        continue;
    }

    u_char *cp = (u_char*)LLADDR(sdl);
    
    macAddress = [NSString stringWithFormat:
                                            @"%02X:%02X:%02X:%02X:%02X:%02X",
                                            cp[0],
                                            cp[1],
                                            cp[2],
                                            cp[3],
                                            cp[4],
                                            cp[5]];
    break;
  }
  
  free(buffer);

  if (macAddress == NULL) {
    NSString *error = @"IP address not found in ARP table";
    completionHandler(nil, error);
  } else {
    completionHandler(macAddress, nil);
  }

}

+ (in_addr_t)convertIPAddress:(NSString *)ipAddress {
  //CONVERT IP ADDRESS TO in_addr_t FORMAT
  const char *net = [ipAddress cStringUsingEncoding:NSASCIIStringEncoding];
  in_addr_t _net = inet_addr(net);
  
  return _net;
}
@end