//
//  EventData.h
//  ServerSentEvents
//
//  Created by Sakatoku Chihiro on 11/08/23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventData : NSObject {
    NSString* eventId;
    NSString* eventName;
    NSString* data;
}

@property (nonatomic, strong) NSString* eventId;
@property (nonatomic, strong) NSString* eventName;
@property (nonatomic, strong) NSString* data;

@end
