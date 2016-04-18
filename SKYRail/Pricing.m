//
//  Pricing.m
//  SKYRail
//
//  Created by YASH on 19/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import "Pricing.h"

@implementation Pricing

- (instancetype)initWithDict:(id)dict
{
    self = [super init];
    
    if (self)
    {
        
        @try
        {
            
            self.trainId = [dict[@"Platform_Id"] integerValue];
            self.baseFare = [NSNumber numberWithFloat:[dict[@"Base_Fare"] floatValue]];
            self.costPerKm = [NSNumber numberWithFloat:[dict[@"Cost_per_km"] floatValue]];
            
        }
        @catch (NSException *exception)
        {
            NSLog(@"User parse error: %@", exception.reason);
        }
        
    }
    
    return self;
}

+ (NSMutableArray <Pricing *> *)returnArrayFromJSONStructure:(id)json
{
    NSMutableArray *pricings = [NSMutableArray new];
    
    @try {
        
        for (id dict in json) {
            
            Pricing *pricing = [[Pricing alloc] initWithDict:dict];
            
            [pricings addObject:pricing];
            
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"User parse error: %@", exception.reason);
    }
    
    return pricings;
}

@end
