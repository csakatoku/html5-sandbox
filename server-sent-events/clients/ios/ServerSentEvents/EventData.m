//
//  EventData.m
//  ServerSentEvents
//
//  Created by Sakatoku Chihiro on 11/08/23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "EventData.h"

@implementation EventData 

@synthesize eventId, eventName, data;

- (NSString*)description
{
    return [NSString stringWithFormat:@"<EventData eventId:%@ eventName:%@ data:%@>", self.eventId, self.eventName, self.data];
}

@end
