//
//  BookingHistory.m
//  SKYRail
//
//  Created by YASH on 19/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import "BookingHistory.h"

@implementation BookingHistory

- (instancetype)initWithDict:(id)dict
{
    self = [super init];
    
    if (self)
    {
        
        @try
        {
            
            self.personId = [dict[@"Person_id"] integerValue];
            self.PNR = [NSNumber numberWithLong:[dict[@"PNR"] longValue]];
            
        }
        @catch (NSException *exception)
        {
            NSLog(@"User parse error: %@", exception.reason);
        }
        
    }
    
    return self;
}

+ (NSMutableArray <BookingHistory *> *)returnArrayFromJSONStructure:(id)json
{
    NSMutableArray *books = [NSMutableArray new];
    
    @try {
        
        for (id dict in json) {
            
            BookingHistory *book = [[BookingHistory alloc] initWithDict:dict];
            
            [books addObject:book];
            
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"User parse error: %@", exception.reason);
    }
    
    return books;
}

@end
