//
//  Platform.m
//  SKYRail
//
//  Created by YASH on 19/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import "Platform.h"

@implementation Platform

- (instancetype)initWithDict:(id)dict
{
    self = [super init];
    
    if (self)
    {
        
        @try
        {
            
            self.platformId = [dict[@"Platform_Id"] integerValue];
            self.xcoord = [dict[@"Xcoord"] integerValue];
            self.ycoord = [dict[@"YCoord"] integerValue];
            self.platformName = [NSString stringWithFormat:@"%@", dict[@"Platform_Name"]];
            
        }
        @catch (NSException *exception)
        {
            NSLog(@"User parse error: %@", exception.reason);
        }
        
    }
    
    return self;
}

+ (NSMutableArray <Platform *> *)returnArrayFromJSONStructure:(id)json
{
    NSMutableArray *platforms = [NSMutableArray new];
    
    @try {
        
        for (id dict in json) {
            
            Platform *platform = [[Platform alloc] initWithDict:dict];
            
            [platforms addObject:platform];
            
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"User parse error: %@", exception.reason);
    }
    
    return platforms;
}

@end
