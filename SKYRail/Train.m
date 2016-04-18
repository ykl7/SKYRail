//
//  Train.m
//  SKYRail
//
//  Created by YASH on 19/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import "Train.h"

@implementation Train

- (instancetype)initWithDict:(id)dict
{
    self = [super init];
    
    if (self)
    {
        
        @try
        {
            
            self.trainId = [dict[@"Train_ID"] integerValue];
            self.capacity = [dict[@"Capacity"] integerValue];
            self.startPid = [dict[@"Startp_ID"] integerValue];
            self.endPid = [dict[@"Endp_ID"] integerValue];
            self.trainName = [NSString stringWithFormat:@"%@", dict[@"Train_name"]];
            
        }
        @catch (NSException *exception)
        {
            NSLog(@"User parse error: %@", exception.reason);
        }
        
    }
    
    return self;
}

+ (NSMutableArray <Train *> *)returnArrayFromJSONStructure:(id)json
{
    NSMutableArray *trains = [NSMutableArray new];
    
    @try {
        
        for (id dict in json) {
            
            Train *train = [[Train alloc] initWithDict:dict];
            
            [trains addObject:train];
            
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"User parse error: %@", exception.reason);
    }
    
    return trains;
}

@end
