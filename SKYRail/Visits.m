//
//  Visits.m
//  SKYRail
//
//  Created by YASH on 19/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import "Visits.h"

@implementation Visits

- (instancetype)initWithDict:(id)dict
{
    self = [super init];
    
    if (self)
    {
        
        @try
        {
            
            self.trainId = [dict[@"Train_ID"] integerValue];
            self.platformId = [dict[@"Platform_Id"] integerValue];
            self.depTime = dict[@"Departure_time"];
            self.arrTime = dict[@"Arrival_time"];
            
        }
        @catch (NSException *exception)
        {
            NSLog(@"User parse error: %@", exception.reason);
        }
        
    }
    
    return self;
}

+ (NSMutableArray <Visits *> *)returnArrayFromJSONStructure:(id)json
{
    NSMutableArray *visits = [NSMutableArray new];
    
    @try {
        
        for (id dict in json) {
            
            Visits *visit = [[Visits alloc] initWithDict:dict];
            
            [visits addObject:visit];
            
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"User parse error: %@", exception.reason);
    }
    
    return visits;
}

@end
