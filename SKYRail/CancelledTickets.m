//
//  CancelledTickets.m
//  SKYRail
//
//  Created by YASH on 19/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import "CancelledTickets.h"

@implementation CancelledTickets

- (instancetype)initWithDict:(id)dict
{
    self = [super init];
    
    if (self)
    {
        
        @try
        {
            
            self.PNR = [NSNumber numberWithLong:[dict[@"PNR"] longValue]];
            self.trainId = [dict[@"Train_ID"] integerValue];
            self.distance = [NSNumber numberWithFloat:[dict[@"Journey_distance"] floatValue]];
            self.startPid = [dict[@"Startp_ID"] integerValue];
            self.endPid = [dict[@"Endp_ID"] integerValue];
            self.dateOfJourney = dict[@"Date_Of_Journey"];
            self.personId = [dict[@"Person_id"] integerValue];
            self.cancelTime = [NSString stringWithFormat:@"%@", dict[@"Deletion_Time"]];
            
        }
        @catch (NSException *exception)
        {
            NSLog(@"User parse error: %@", exception.reason);
        }
        
    }
    
    return self;
}

+ (NSMutableArray <CancelledTickets *> *)returnArrayFromJSONStructure:(id)json
{
    NSMutableArray *cancelledTickets = [NSMutableArray new];
    
    @try {
        
        for (id dict in json) {
            
            CancelledTickets *cancelledTicket = [[CancelledTickets alloc] initWithDict:dict];
            
            [cancelledTickets addObject:cancelledTicket];
            
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"User parse error: %@", exception.reason);
    }
    
    return cancelledTickets;
}

@end
